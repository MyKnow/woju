#!/bin/bash

# 현재 브랜치 이름 가져오기
current_branch=$(git rev-parse --abbrev-ref HEAD)

# 현재 브랜치가 "develop"나 "main"이라면 에러 메시지 출력 후 종료
if [[ $current_branch == "develop" ]] || [[ $current_branch == "main" ]]; then
    echo "현재 브랜치가 $current_branch 입니다. 다른 브랜치에서 실행해주세요."
    exit 1
fi

# 현재 브랜치 명을 보여주고, 삭제할 것인지 확인
echo "현재 브랜치: $current_branch"
read -p "위 브랜치를 삭제하시겠습니까? (y/n): " confirm

# 사용자가 y를 입력하지 않으면 종료
if [[ $confirm != "y" ]]; then
    echo "종료합니다."
    exit 1
fi

# branch 변경
git checkout develop

# 원격 저장소에서 브랜치 삭제
git push origin --delete $current_branch

# 로컬에서 브랜치 삭제
git branch -d $current_branch