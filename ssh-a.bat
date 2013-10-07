@echo off
set SSH_ENV_LOG=%~dpn0_env.log
setlocal
set DEST_LABEL=normal
set SSH_AGENT_PID_LOCAL=
set SSH_AUTH_SOCK_LOCAL=
if EXIST %SSH_ENV_LOG% (
	for /f "eol= tokens=1-2 delims==" %%1 in (%SSH_ENV_LOG%) do (
		set %%1_LOCAL=%%2
	)
)
for /f "eol= tokens=1 delims= " %%1 in ('ps ^| grep ssh-agent') do (
	if not "%%1" == "" (
		if "%SSH_AGENT_PID%" == "%%1" (
			set DEST_LABEL=bypass_to_run_SSH-Agent
		) else (
			if "%SSH_AGENT_PID_LOCAL%" == "%%1" (
				set DEST_LABEL=read_env_log
			) else (
				set SSH_AGENT_PID=%%1
				ssh-agent -k>nul
			)
		)
	)
)
goto %DEST_LABEL%
:normal
for /f "eol=; tokens=1,2 delims==;" %%1 in ('ssh-agent') do (
	if "%%1" == "SSH_AUTH_SOCK" set %%1_LOCAL=%%2
	if "%%1" == "SSH_AGENT_PID" set %%1_LOCAL=%%2
)
echo SSH_AGENT_PID=%SSH_AGENT_PID_LOCAL%> %SSH_ENV_LOG%
echo SSH_AUTH_SOCK=%SSH_AUTH_SOCK_LOCAL%>>%SSH_ENV_LOG%
:read_env_log
endlocal
for /f "eol= tokens=1-2 delims==" %%1 in (%SSH_ENV_LOG%) do (
	set %%1=%%2
)
:bypass_to_run_SSH-Agent
endlocal
for /f "eol= tokens=1 delims= " %%1 in ('ssh-add -l ^| grep "The agent has no identities."') do (
	if not "%%1" == "" (
		ssh-add
	)
)
set SSH_ENV_LOG=
@echo on