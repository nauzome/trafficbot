#!/bin/bash
cd /root/bot/

#config
interface=""
misskey_token=""
telegram_token=""
telegram_to=""
tor_rs=""

rx_bytes=$(ifconfig $interface | grep "RX packets" | awk '{print $5}')
cumulative=$(expr $rx_bytes / 1073741824)
source ./yesterday.sh
today=$(expr $cumulative - $yesterday)

if [ "1000" -gt $today ]; then
    encode_today="$today""GB"
fi
if [ $today -gt "1000" ]; then
    encode_today=$(expr $today / 1000)
    encode_today="$encode_today""TB"
fi
if [ $today -gt "1000000" ]; then
    encode_today=$(expr $today / 1000000)
    encode_today="$encode_today""PB"
fi

if [ "1000" -gt $cumulative ]; then
    cumulative_today="$cumulative""GB"
fi
if [ $cumulative -gt "1000" ]; then
    cumulative_today=$(expr $cumulative / 1000)
    cumulative_today="$cumulative_today""TB"
fi
if [ $cumulative -gt "1000000" ]; then
    cumulative_today=$(expr $cumulative / 1000000)
    cumulative_today="$cumulative_today""PB"
fi

message_echo=$"The traffic today(24 hours)was ""$encode_today".""$'\n'"The current cumulative traffic is ""$cumulative_today""."$'\n'"We are proud to support the free speech and privacy rights of people everywhere."$'\n'"let's meet again tomorrow!"$'\n'""$'\n'"今日(24時間)のトラフィックは""$encode_today""でした。"$'\n'"現在の累積トラフィックは""$cumulative_today""です。"$'\n'"私たちは、あらゆる場所の人々の言論の自由とプライバシーの権利をサポートすることを誇りに思っています。"$'\n'"また明日お会いしましょう！"$'\n'""$'\n'"https://metrics.torproject.org/rs.html#details/""$tor_rs"$'\n'"https://about.nauzo.me/project";
message=$"The traffic today(24 hours)was ""$encode_today"."\nThe current cumulative traffic is ""$cumulative_today"".\nWe are proud to support the free speech and privacy rights of people everywhere.\nlet's meet again tomorrow!\n\n今日(24時間)のトラフィックは""$encode_today""でした。\n現在の累積トラフィックは""$cumulative_today""です。\n私たちは、あらゆる場所の人々の言論の自由とプライバシーの権利をサポートすることを誇りに思っています。\nまた明日お会いしましょう！\n\nhttps://metrics.torproject.org/rs.html#details/""$tor_rs""\nhttps://about.nauzo.me/project";
message_tg=$"The traffic today(24 hours)was ""$encode_today"."\nThe current cumulative traffic is ""$cumulative_today"".\nWe are proud to support the free speech and privacy rights of people everywhere.\nlet's meet again tomorrow!\n\n今日(24時間)のトラフィックは""$encode_today""でした。\n現在の累積トラフィックは""$cumulative_today""です。\n私たちは、あらゆる場所の人々の言論の自由とプライバシーの権利をサポートすることを誇りに思っています。\nまた明日お会いしましょう！\n\nhttps://metrics.torproject.org/rs.html#details/""$tor_rs""";

curl -X POST -H "Content-Type: application/json" -d @- https://misskey.pm/api/notes/create << EOS
{"i":"$misskey_token","visibility":"public","text":"$message"}
EOS

curl -X POST -H "Content-Type: application/json" -d @- https://api.telegram.org/bot"$telegram_token"/sendMessage << EOS
{"chat_id":"$telegram_to","text":"$message_tg"}
EOS

echo -e '#!/bin/bash'$'\n''yesterday="'$cumulative'"' > yesterday.sh;