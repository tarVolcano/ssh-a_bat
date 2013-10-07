◆使い方
・NYAOS+Console2：cmdsource "ssh-a.bat"を実行。
　(_nyaファイルでaliasを指定して、ついでに実行すると良い)
・DOS：ssh-a.batを実行

	※バッチ実行後、ssh -T git@github.com などで接続確認してください。


◆バッチの目的
・DOSまたは、NYAOS+Console2でssh-agentを起動する。
	・ssh-agentで使う環境変数を"バッチファイル名_env.log"に記録、プロンプト起動時に変数が不足していたら再setする。
	・ssh-agentを重複起動しないようにする。もし、制御できない(環境変数の記録がない)プロセスがあればkillする。
・ssh-add -l で一つも鍵が登録されてなければ、ssh-addも実行する。
	・一つでも登録されていればssh-addは行わない。


◆事前準備
・git\binのパスが通っている(msys のコマンドを使うので)
・環境変数HOMEが設定されている
・%HOME%\.sshのconfigファイルが設定されている


◆環境
・Git for Windows v1.8.4
・NYAOS 3.3.8_2
・Console2 2.00.148
・Windows XP Pro SP3
