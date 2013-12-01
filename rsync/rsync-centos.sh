set -e
 
# 此脚本由 http://www.debian.org/mirror/anonftpsync 修改而来
# 需要原脚本可以自行下载
# CVS: cvs.debian.org:/cvs/webwml - webwml/english/mirror/anonftpsync
# Version: $Id: anonftpsync,v 1.43 2008-06-15 18:16:04 spaillar Exp $
 
#增加mirror名变量，方便修改log名、lock名、mail信息
MIRROR="centos-6.4-os-i386"
 
RSYNC="/usr/bin/rsync"
TO="/mirrors/centos/6.4/os/i386"
RSYNC_HOST="mirrors.ustc.edu.cn"
RSYNC_DIR="centos/6.4/os/i386/"
LOGDIR="/log"
 
# ARCH_EXCLUDE 控制需要排除的架构的包
# 对于Debian,以下是包含的架构
# alpha, amd64, arm, armel, hppa, hurd-i386, i386, ia64, m68k, mipsel, mips, powerpc, s390, sh and sparc
# 一个比较特殊的值: source
# 它将排除源代码包
# 例子
# ARCH_EXCLUDE="alpha arm armel hppa hurd-i386 ia64 m68k mipsel mips s390 sparc"
#对于opensuse:
#这里应该是: x86_64 i586 i686 noarch source
#ARCH_EXCLUDE="alpha,  arm, armel, hppa, hurd-i386, i386, ia64, m68k, mipsel, mips, powerpc, s390, sh,sparc,source"
ARCH_EXCLUDE="" 
# EXCLUDE变量将排除更多需要排除的包,非得以不建议使用这个变量
# The following example would exclude mostly everything:
#EXCLUDE="\
#  --exclude stable/ --exclude testing/ --exclude unstable/ \
#  --exclude source/ \
#  --exclude *.orig.tar.gz --exclude *.diff.gz --exclude *.dsc \
#  --exclude /contrib/ --exclude /non-free/ \
# "
EXCLUDE=
 
#mail地址
#同步完成后把log发到指定邮箱,需要修改exim配置
MAILTO=
 
# LOCK_TIMEOUT是一个时间锁,以分钟为单位,默认锁6小时,即360分钟.
# 脚本运行时将创建lock文件,以保证同时间内只有一个rsync再运行
# 不同同步脚本的lock不能互相影响,以不同文件名区分.
LOCK_TIMEOUT=360
 
# RSYNC代理设置,一般不需要设置
# RSYNC_PROXY="IP:PORT"
# export RSYNC_PROXY=$RSYNC_PROXY
 
# 帐号密码设置
# . ftpsync.conf
# export RSYNC_PASSWORD
# RSYNC_HOST=$RSYNC_USER@$RSYNC_HOST
 
# 检查各个重要变量是否为空
if [ -z "$TO" ] || [ -z "$RSYNC_HOST" ] || [ -z "$RSYNC_DIR" ] || [ -z "$LOGDIR" ] || [ -z "$RSYNC" ]; then
    echo "One of the following variables seems to be empty:"
    echo "TO, RSYNC_HOST, RSYNC_DIR or LOGDIR"
    exit 2
fi
 
#hostname变量,也可以手工指定
HOSTNAME=`hostname -f`
# HOSTNAME=mirror.domain.tld
 
#LOCK文件,绝对路径,建议放在统一目录,便于管理
LOCK="/lock/$MIRROR-Archive-Update-in-Progress-${HOSTNAME}"
 
# 临时目录,由rsync --delay-updates 参数决定
# 必须保留,以避免错误,同步时所有新下载的都自动存放在临时目录
TMP_EXCLUDE="--exclude .~tmp~/"
 
# 架构排除变量的展开语句
#以下是原脚本的,只适用debian系的部分发行版
for ARCH in $ARCH_EXCLUDE; do
   EXCLUDE=$EXCLUDE"\
       --exclude binary-$ARCH/ \
       --exclude disks-$ARCH/ \
       --exclude installer-$ARCH/ \
       --exclude Contents-$ARCH.gz \
       --exclude Contents-$ARCH.diff/ \
       --exclude arch-$ARCH.files \
       --exclude arch-$ARCH.list.gz \
       --exclude *_$ARCH.deb \
       --exclude *_$ARCH.udeb "
   if [ "$ARCH" = "source" ]; then
       SOURCE_EXCLUDE="\
       --exclude source/ \
       --exclude *.tar.gz \
       --exclude *.diff.gz \
       --exclude *.dsc "
   fi
done
#以下是为opensuse专门修改的
#for ARCH in $ARCH_EXCLUDE; do
#    EXCLUDE=$EXCLUDE"\
#        --exclude *.$ARCH.rpm"
#    if [ "$ARCH" = "source" ]; then
#        SOURCE_EXCLUDE="\
#        --exclude source/"
#    fi
#done
 
#日志文件
LOGFILE=$LOGDIR/$MIRROR-mirror.log
# 可以使用下面的命名方式
# LOGFILE=$LOGDIR/$(echo $RSYNC_DIR | tr / _)-mirror.log
# LOGFILE=$LOGDIR/${RSYNC_DIR/\//_}-mirror.log
 
cd $HOME
umask 002
 
# 在第一次运行时创建trace文件,记录每次同步的时间记录
# 只在Debian的镜像中发现有此文件,其他发行版一般不需要
if [ ! -d "${TO}/project/trace/" ]; then
  mkdir -p ${TO}/project/trace
fi
 
# 判断是否有同一脚本的rsync在运行,可以避免上一同步还没完而起多一个同步进程
if [ -f "$LOCK" ]; then
# Note: this requires the findutils find; for other finds, adjust as necessary
  if [ "find $LOCK -maxdepth 1 -cmin -$LOCK_TIMEOUT" = "" ]; then
# Note: this requires the procps ps; for other ps', adjust as necessary
    if ps ax | grep '[r]'sync | grep -q $RSYNC_HOST; then
      echo "stale lock found, but a rsync is still running, aiee!"
      exit 1
    else
      echo "stale lock found (not accessed in the last $LOCK_TIMEOUT minutes), forcing update!"
      rm -f $LOCK
    fi
  else
    echo "current lock file exists, unable to start rsync!"
    exit 1
  fi
fi
 
#生成lock
touch $LOCK
 
# 在部分非debian系统,需要用0代替exit
# 捕捉退出信号,以删除lock
# 脚本结尾也有一句同样效果的,这里起保证异常退出时能删除lock的作用
# 单rsync错误，还是顺序执行到最后的rm,然后再触发这里的trap
# 保证的是父进程的异常退出
trap "rm -f $LOCK" exit
 
# 我根据需要加的,可在手工运行脚本时,捕捉ctrl+c
# 这样能再按下ctrl+c后继续保存log及删除lock文件
trap "" 2
 
set +e
 
# 我根据需要加的,写个时间进log,方便查
date +["Start "%F" "%T] >> $LOGFILE
 


echo "start RSYNC" 
# debian的原脚本把rsync分两步,先同步poor的内容
# 其他发行版不需要这么做
# timeout参数能在出现io错误时自动结速脚本,而不卡住
# delay-updates参数:先把下载的数据放tmp目录,同步完再移到正确位置
# 必须加此参数,可以避免未同步完的不完整包被用户下载导致错误
# 对于第一次同步，建议增加--size-only及--ignore-existing，以增加同步速度(在经常断开的情况下)
# 对于想删除不需要的exclude文件情况，可以增加--delete-excluded及--force(force用来强制删除空的不必要目录)
$RSYNC --recursive -p --links --hard-links --times \
     --progress \
     --verbose \
     --size-only --ignore-existing \
     --delay-updates --delete-after \
     --timeout=3600 \
     --bwlimit=5500 \
     $TMP_EXCLUDE $EXCLUDE $SOURCE_EXCLUDE \
     $RSYNC_HOST::$RSYNC_DIR $TO/ >> $LOGFILE 2>&1
 
#chtime.sh用来记录源正常完成更新的时间
if [ $? -eq 0 ]
then
#    /home/mirror.scripts/bin/chtime.sh opensuse >> $LOGFILE 2>&1
echo "chtime"
fi
 
#写时间进trace文件,非debian系统不需要
#LANG=C date -u > "${TO}/project/trace/${HOSTNAME}"
 
#写结束时间进log
date +["End "%F" "%T] >> $LOGFILE
 
#寄送邮件
if [ -n "$MAILTO" ]; then
    mail -s "$MIRROR archive synced" $MAILTO < $LOGFILE
fi
 
#保存log
savelog $LOGFILE >/dev/null
 
#最后删除lock文件
rm $LOCK

