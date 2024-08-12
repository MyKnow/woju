#!/bin/bash

# 현재 branch를 확인
current_branch=$(git rev-parse --abbrev-ref HEAD)

# 현재 branch가 develop으로 시작하는지 확인하고, 맞다면 에러 메시지 출력 후 종료
if [[ $current_branch == "develop" ]]; then
    echo "현재 branch가 develop입니다. Update를 다른 Branch에서 시도해주세요."
    exit 1
fi

# 유저에게 커밋 메시지 타입을 선택하도록 프롬프트
echo "커밋 메시지 타입을 선택해주세요:"
echo "1) feat: 새로운 기능 추가"
echo "2) fix: 버그 수정"
echo "3) docs: 문서 수정"
echo "4) style: 코드 스타일 변경"
echo "5) design: 사용자 UI 디자인 변경"
echo "6) test: 테스트 코드, 리팩토링 테스트 코드 추가"
echo "7) refactor: 코드 리팩토링"
echo "8) build: 빌드 파일 수정"
echo "9) ci: CI 설정 파일 수정"
echo "10) perf: 성능 개선"
echo "11) chore: 코드 수정이 아닌 설정을 변경 (gitignore, 스크립트 수정 등)"
echo "12) rename: 파일 혹은 폴더명을 수정만 한 경우"
echo "13) remove: 파일을 삭제만 한 경우"
read -p "번호를 입력하세요: " type_number

# 커밋 메시지 타입 설정
case $type_number in
    1) commit_type="feat";;
    2) commit_type="fix";;
    3) commit_type="docs";;
    4) commit_type="style";;
    5) commit_type="design";;
    6) commit_type="test";;
    7) commit_type="refactor";;
    8) commit_type="build";;
    9) commit_type="ci";;
    10) commit_type="perf";;
    11) commit_type="chore";;
    12) commit_type="rename";;
    13) commit_type="remove";;
    *) echo "잘못된 번호입니다."; exit 1;;
esac

# 유저에게 커밋 메시지를 입력받음
read -p "커밋 메시지를 입력해주세요: " commit_message

# license 업데이트
# echo -e "Updating licenses...\n"
# flutter pub run flutter_oss_licenses:generate.dart

# release branch에서만 버전 업데이트 가능
if [[ $current_branch == "release" ]]; then
  # 현재 버전 확인
  current_version=$(grep 'version: ' pubspec.yaml | sed 's/version: //')
  major=$(echo $current_version | cut -d '.' -f1)
  sub=$(echo $current_version | cut -d '.' -f2)
  minor=$(echo $current_version | cut -d '.' -f3 | cut -d '+' -f1)
  build=$(echo $current_version | cut -d '+' -f2)

  # 버전 업데이트 타입 선택
  echo -e "\nUpdate Type을 선택해주세요. (현재 Version: $current_version):"
  echo "1: Main Version Update (+1.x.x)"
  echo "2: Sub Version Update (x.+1.x)"
  echo "3: Minor Version Update (x.x.+1)"
  echo "4: Version Update 하지 않음"
  read -p "선택(1~4): " choice


  # 선택에 따라 버전 업데이트
  case $choice in
    1) # Main version update
      let major+=1
      sub=0
      minor=0
      ;;
    2) # Sub version update
      let sub+=1
      minor=0
      ;;
    3) # Minor version update
      let minor+=1
      ;;
    4) # No version update
      let build-=1
      ;;
    *)
      echo "잘못된 선택입니다."
      exit 1
      ;;
  esac

  # 빌드 번호 업데이트
  let build+=1

  # 새로운 버전 생성
  new_version="${major}.${sub}.${minor}+${build}"

  # pubspec.yaml에 새로운 버전 업데이트
  sed -i '' "s/version: .*/version: ${new_version}/" pubspec.yaml

  # Dart File에 새로운 버전 업데이트
  # dart_file_path="lib/services/app_version_service.dart"
  # sed -i '' "s/return \"$current_version\";/return \"$new_version\";/" $dart_file_path

  # pubspec.yaml에 새로운 버전 업데이트 확인
  echo -e "\n버전 업데이트 완료: ${current_version} -> ${new_version}"
fi

# 암호화
# 파일 목록
files=("firebase.json" ".env" "android/app/google-services.json" "ios/Runner/GoogleService-Info.plist")

# 변경된 파일 목록 초기화
changed_files=()

# 임시 디렉토리 생성
tmp_dir=$(mktemp -d)

# 원본 파일에 대한 SHA-256 해시 값 읽기 및 저장
for file in "${files[@]}"; do
  sha256_file="$file.sha256"
  if [ -f "$sha256_file" ]; then
    cat "$sha256_file" > "$tmp_dir/$(basename $file).sha256"
  fi
done

# 새로운 SHA-256 해시 파일 생성
for file in "${files[@]}"; do
  if [ -f "$file" ]; then
    sha256sum "$file" > "$file.sha256"
    echo "$file 파일의 새로운 SHA-256 해시를 $file.sha256 파일로 저장했습니다."
  else
    echo "$file 파일이 존재하지 않습니다."
  fi
done

echo -e "\n파일 변경 사항을 확인합니다."

# 새로운 SHA-256 해시 값 읽기 및 비교
for file in "${files[@]}"; do
  sha256_file="$file.sha256"
  old_sha256_file="$tmp_dir/$(basename $file).sha256"
  if [ -f "$sha256_file" ]; then
    new_hash=$(cat "$sha256_file")
    if [ -f "$old_sha256_file" ]; then
      old_hash=$(cat "$old_sha256_file")
      if [ "$old_hash" != "$new_hash" ]; then
        echo "$file 파일이 변경되었습니다."
        changed_files+=("$file")
      else
        echo "$file 파일이 변경되지 않았습니다."
      fi
    else
      echo "$old_sha256_file 파일이 존재하지 않습니다. 변경 사항을 확인할 수 없습니다."
      changed_files+=("$file")
    fi
  else
    echo "$sha256_file 파일이 존재하지 않습니다."
  fi
done

# 변경된 파일이 있는 경우 암호화 진행
if [ ${#changed_files[@]} -ne 0 ]; then
  echo -e "\n변경된 파일이 있습니다. 암호화를 진행합니다."
  echo -e "\n암호를 입력해주세요 : "
  read -s password
  
  for file in "${changed_files[@]}"; do
    openssl aes-256-cbc -pbkdf2 -in "$file" -out "$file.enc" -k $password
    echo "$file 파일을 암호화했습니다."
  done
else
  echo -e "\n파일이 변경되지 않았습니다. 암호화를 진행하지 않습니다."
fi

# 임시 디렉토리 삭제
rm -rf "$tmp_dir"



# 최종 확인
echo "커밋 메시지 -> $commit_type: $commit_message"
read -p "이대로 진행하시겠습니까? (y/n): " confirm

# 유저가 y를 입력하지 않으면 종료
if [[ $confirm != "y" ]]; then
    echo "종료합니다."
    exit 1
fi

# 변경 사항 추가 및 커밋
git add .
git commit -m "$commit_type: $commit_message"
git push origin $current_branch

# 현재 branch가 release branch인 경우 develop branch로 merge
if [[ $current_branch == "release" ]]; then
  # 태그 생성
  tag="v$new_version"

  # 변경 사항 추가 및 커밋
  git add .
  git commit -m "$current_branch: $tag"

  # 위 커밋의 해시값 확인
  commit_hash=$(git rev-parse HEAD)

  # 위 커밋 해시에 대한 tag 생성
  git tag -a $tag $commit_hash -m "$new_version 버전 릴리즈"

  # tag 생성 성공 여부 확인
  if [ $? -ne 0 ]; then
      echo "Tag 생성 실패."
      exit 1
  fi

  # push
  git push origin $current_branch
  git push origin $tag

  # tag push 성공 여부 확인
  if [ $? -ne 0 ]; then
      echo "Tag push 실패."
      exit 1
  fi

  git checkout develop
  git pull origin develop
  git merge release -m "Merge branch 'release' into develop"
  git push origin develop
  git checkout $current_branch
fi
