#!/bin/bash

# 현재 develop branch에서, 새로운 feature 브랜치를 생성하는 스크립트

# develop branch를 최신화
git checkout develop
git pull origin develop

# 유저로부터 새로 생성 할 branch의 이름을 입력 받음 (공백 포함 가능)
read -p "새로 생성 할 branch의 이름을 입력해주세요: " branch_name

# branch_name이 공백이 포함되어 있다면 공백을 -로 변경
branch_name=$(echo $branch_name | sed 's/ /-/g')

# branch_name의 앞에 feature/ 를 붙여서 새로운 branch 이름 생성
branch_name="feature/$branch_name"

# develop branch에서 새로운 feature branch 생성
git checkout -b $branch_name develop

# 새로운 branch를 원격 저장소에 push
git push origin $branch_name

# push 명령의 결과 확인
if [ $? -eq 0 ]; then
  echo "새로운 feature 브랜치 '$branch_name'가 생성되고 원격 저장소에 푸시되었습니다."
else
  echo "원격 저장소에 푸시하는 동안 오류가 발생했습니다."
fi

# VSCode에서 Git 상태 갱신을 위해 Git GUI를 새로 고침하라는 메시지 출력
echo "VSCode에서 Git 상태를 새로 고침하세요."
