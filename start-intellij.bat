@echo off

if defined DISPLAY (
    docker run ^
    -tdi ^
    -e DISPLAY=%DISPLAY% ^
    --net=host ^
    --pid=host ^
    --ipc=host ^
    -v %HOMEDRIVE%%HOMEPATH%/.IdeaIC2016.3_docker:/home/developer/.IdeaIC2016.3 ^
    jasonkdarby/docker-cursive-ide
) else (
    echo DISPLAY is not set in the environment.
)