docker run ^
-tdi ^
-e DISPLAY=%DISPLAY% ^
--net=host ^
--pid=host ^
--ipc=host ^
-v %HOMEDRIVE%%HOMEPATH%/.IdeaIC2016.3_docker:/home/developer/.IdeaIC2016.3 ^
jasonkdarby/docker-cursive-ide