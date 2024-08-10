#!/bin/bash

# 아직 변경사항이 있는지 확인
if [[ $(git status --porcelain) ]]; then
    echo "아직 변경사항이 있는 상태입니다. 변경사항을 커밋해주세요."
    exit 1
fi

# 현재 작업 중인 브랜치 확인
current_branch=$(git rev-parse --abbrev-ref HEAD)

# 현재 브랜치가 feature/로 시작하지 않으면 종료
if [[ $current_branch != feature/* ]]; then
    echo "현재 브랜치가 feature/로 시작하지 않습니다. feature 브랜치에서 실행해주세요."
    exit 1
fi

# merge를 시도할 것인지 확인
echo "현재 브랜치: $current_branch"
read -p "위 브랜치를 develop 브랜치로 merge하시겠습니까? (y/n): " confirm

# 사용자가 y를 입력하지 않으면 종료
if [[ $confirm != "y" ]]; then
    echo "종료합니다."
    exit 1
fi

# 현재 브랜치를 develop 브랜치로 merge
git checkout develop
git pull origin develop
git merge $current_branch -m "$current_branch branch merge into develop"


# merge 성공 여부 확인 후, develop 브랜치로 push
if [ $? -eq 0 ]; then
    echo "병합 성공. develop 브랜치로 push 시도 중..."
    git push origin develop
    git checkout develop

    # feature 브랜치 삭제 여부 확인
    read -p "feature 브랜치를 삭제하시겠습니까? (y/n): " confirm

    if [[ $confirm == "y" ]]; then
        git branch -d $current_branch

        if [ $? -ne 0 ]; then
            echo "feature 브랜치를 삭제하지 못했습니다."
            exit 1
        fi

        git push origin --delete $current_branch
        echo "feature 브랜치를 삭제했습니다."
    else
        echo "feature 브랜치를 삭제하지 않았습니다."
    fi

    echo "작업이 완료되었습니다."
else
    echo "병합 실패. develop 브랜치로 push를 시도하지 않습니다."
fi