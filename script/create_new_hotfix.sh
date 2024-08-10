#!/bin/bash

# 현재 main branch에서, 새로운 hotpix 브랜치를 생성하는 스크립트

# main branch를 최신화
git checkout main
git pull origin main

# 유저로부터 새로 생성 할 branch의 이름을 입력 받음 (공백 포함 가능)
read -p "새로 생성 할 branch의 이름을 입력해주세요: " branch_name

# branch_name이 공백이 포함되어 있다면 공백을 -로 변경
branch_name=$(echo $branch_name | sed 's/ /-/g')

# branch_name의 앞에 hotfix/ 를 붙여서 새로운 branch 이름 생성
branch_name="hotfix/$branch_name"

# main branch에서 새로운 hotfix branch 생성
git checkout -b $branch_name hotfix

# 새로운 branch를 원격 저장소에 push
git push origin $branch_name

echo "새로운 hotfix 브랜치 '$branch_name'가 생성되고 원격 저장소에 푸시되었습니다."
