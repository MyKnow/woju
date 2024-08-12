# 설명: 작업 시작 전, 현재 브랜치를 최신으로 업데이트하고, 암호화된 파일을 복호화한다.

# 현재 브랜치를 최신으로 업데이트한다.
git pull origin $(git rev-parse --abbrev-ref HEAD)

# 암호화된 파일을 복호화한다.
files=("firebase.json" ".env" "android/app/google-services.json" "ios/Runner/GoogleService-Info.plist")

echo "암호를 입력하세요 : "
read -s password

for file in ${files[@]}; do
  echo -e "\nDecrypting $file..."
  openssl enc -d -aes-256-cbc -in $file.enc -out $file -k $password
  if [ $? -ne 0 ]; then
    echo "Decryption failed."
    exit 2
  fi
done


# 복호화 성공 여부 확인
if [ $? -ne 0 ]; then
  echo "Decryption failed."
  exit 2
fi

echo "git pull 및 파일 복호화가 완료되었습니다."