#!/bin/bash

# 현재 branch가 develop인지 확인
current_branch=$(git branch --show-current)

if [ $current_branch != "develop" ]; then
  echo "현재 branch가 develop이 아닙니다. develop branch에서 실행해주세요."
  exit 1
fi

# license 업데이트
# echo -e "Updating licenses...\n"
# flutter pub run flutter_oss_licenses:generate.dart

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

# 암호화
# 파일 목록
files=("firebase.json" ".env" "android/app/google-services.json" "ios/Runner/GoogleService-Info.plist")

# 파일 암호화
echo -e "\n	파일 암호화를 위해 암호를 입력하세요 : "
read -s password
for file in ${files[@]}; do
  echo -e "\nEncrypting $file..."
  openssl enc -aes-256-cbc -salt -in $file -out $file.enc -k $password
  if [ $? -ne 0 ]; then
    echo "암호화 실패."
    exit 2
  fi
done

# 최종 확인
echo -e "\n버전 업데이트 완료: ${current_version} -> ${new_version}"

# Git commit and push
git add .
echo "build: [${new_version}]" > .git/COMMIT_EDITMSG
git commit -F .git/COMMIT_EDITMSG
git push origin develop

# 버전 업데이트가 완료된 release branch 생성
git checkout -b release -t origin/develop

# release branch에 push
git push origin release

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

echo -e "\n새로운 release 브랜치가 생성되었고 원격 저장소에 푸시되었습니다."
