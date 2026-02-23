#!/bin/bash

# 사용법: run_exp.sh [-l logfile] <script.py> [python args...]
# 예시:   run_exp.sh -l expr.log main.py --lr 0.001

SLACK_WEBHOOK="${SLACK_WEBHOOK_URL}"

# -l 옵션 파싱
LOGFILE=""
while getopts ":l:" opt; do
    case $opt in
        l) LOGFILE="$OPTARG" ;;
        :) echo "-$OPTARG 옵션은 인자가 필요합니다."; exit 1 ;;
        \?) echo "알 수 없는 옵션: -$OPTARG"; exit 1 ;;
    esac
done
shift $((OPTIND - 1))  # 파싱된 옵션 제거, 이후 $@는 python 명령어

SCRIPT=$1
# -l 미지정 시 '스크립트명_날짜_시각'으로 자동 생성
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
LOGFILE="${LOGFILE:-${SCRIPT%.py}_${TIMESTAMP}.log}"

START_TIME=$(date '+%Y-%m-%d %H:%M:%S')
python "$@" > "$LOGFILE" 2>&1
EXIT_CODE=$?
END_TIME=$(date '+%Y-%m-%d %H:%M:%S')

if [ $EXIT_CODE -eq 0 ]; then
    STATUS="✅ 성공"
else
    STATUS="❌ 실패 (exit: $EXIT_CODE)"
    TAIL_LOG=$(tail -n 10 "$LOGFILE")
fi

MESSAGE="*[$STATUS] \`$SCRIPT\`*
시작: $START_TIME
종료: $END_TIME
로그: \`$LOGFILE\`"

if [ $EXIT_CODE -ne 0 ]; then
    MESSAGE="$MESSAGE
\`\`\`$TAIL_LOG\`\`\`"
fi

curl -s -X POST $SLACK_WEBHOOK \
  -H 'Content-type: application/json' \
  -d "{\"text\":\"$MESSAGE\"}" > /dev/null

exit $EXIT_CODE
