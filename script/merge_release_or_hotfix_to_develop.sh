#!/bin/bash

# 현재 branch가 release인지 확인
current_branch=$(git branch --show-current)

# release branch나 hotfix/ branch가 아니라면 에러 메시지 출력 후 종료
if [[ $current_branch != "release" ]] && [[ $current_branch != "hotfix/"* ]]; then
  echo "현재 branch가 release 또는 hotfix가 아닙니다. 해당 branch에서 실행해주세요."
  exit 1
fi

# develop branch로는 merge, main branch로는 PR을 생성
read -p "$current_branch 브랜치를 develop 브랜치로 merge하시겠습니까? (y/n): " confirm

# 사용자가 y를 입력하지 않으면 종료
if [[ $confirm != "y" ]]; then
    echo "종료합니다."
    exit 1
fi

# 현재 버전 확인
current_version=$(grep 'version: ' pubspec.yaml | sed 's/version: //')


# 현재 브랜치를 develop 브랜치로 merge
git checkout develop
git pull origin develop
git merge release

# merge 성공 여부 확인
if [ $? -eq 0 ]; then
    echo "병합 성공. develop 브랜치로 push 시도 중..."
    git push origin develop
    git checkout $current_branch
else
    echo "병합 실패. develop 브랜치로 push를 시도하지 않습니다."
    git checkout $current_branch
    exit 1
fi

echo "$current_branch 브랜치를 develop 브랜치로 성공적으로 merge하였습니다."
echo "PR을 통해 main 브랜치로 merge 후, close_branch.sh를 통해 $current_branch 브랜치를 삭제해주세요."