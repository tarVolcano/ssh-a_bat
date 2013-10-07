@echo off
set SSH_ENV_LOG_LOCAL=%~dpn0_env.log
setlocal
set isExist_SA=0
set SSH_AGENT_PID_LOCAL=
set SSH_AUTH_SOCK_LOCAL=
if EXIST %SSH_ENV_LOG_LOCAL% (
	for /f "eol= tokens=1-2 delims==" %%1 in (%SSH_ENV_LOG_LOCAL%) do (
		set %%1_LOCAL=%%2
	)
)
set isExist_SA=0
for /f "eol= tokens=1 delims= " %%1 in ('ps ^| grep ssh-agent') do (
	if not "%%1" == "" (
		if "%SSH_AGENT_PID%" == "%%1" (
			set isExist_SA=1
		) else (
			if "%SSH_AGENT_PID_LOCAL%" == "%%1" (
				set isExist_SA=2
			) else (
				kill %%1
			)
		)
	)
)
if %isExist_SA% == 1 goto running_SSH-Agent
if %isExist_SA% == 2 goto replace_env
for /f "eol=; tokens=1,2 delims==;" %%1 in ('ssh-agent') do (
	if "%%1" == "SSH_AUTH_SOCK" set %%1_LOCAL=%%2
	if "%%1" == "SSH_AGENT_PID" set %%1_LOCAL=%%2
)
echo SSH_AGENT_PID=%SSH_AGENT_PID_LOCAL%> %SSH_ENV_LOG_LOCAL%
echo SSH_AUTH_SOCK=%SSH_AUTH_SOCK_LOCAL%>>%SSH_ENV_LOG_LOCAL%
:replace_env
endlocal
for /f "eol= tokens=1-2 delims==" %%1 in (%SSH_ENV_LOG_LOCAL%) do (
	set %%1=%%2
)
:running_SSH-Agent
endlocal
for /f "eol= tokens=1 delims= " %%1 in ('ssh-add -l ^| grep "The agent has no identities."') do (
	if not "%%1" == "" (
		ssh-add
	)
)
set SSH_ENV_LOG_LOCAL=
@echo on