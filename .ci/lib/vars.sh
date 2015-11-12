export PATH=/sbin:/usr/sbin:${PATH}:${HOME}/bin

# Include build vars if possible
if [ -x /etc/profile.d/build.sh ]; then
    source /etc/profile.d/build.sh
fi

