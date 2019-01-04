#!/bin/bash

echo -e "\x1B[34m \n" \
"                   -\`                     \n" \
"                  .o+\`                    \n" \
"                \`ooo/                     \n" \
"                \`+oooo:                   \n" \
"               \`+oooooo:                  \n" \
"               -+oooooo+:                  \n" \
"             \`/:-:++oooo+:                \n" \
"            \`/++++/+++++++:               \n" \
"          \`/++++++++++++++:               \n" \
"         \`/+++ooooooooooooo/\`            \n" \
"        ./ooosssso++osssssso+\`            \n" \
"        .oossssso-\`\`\`\`/ossssss+\`      \n" \
"      -osssssso.      :ssssssso.           \n" \
"     :osssssss/        osssso+++.          \n" \
"     /ossssssss/        +ssssooo/-         \n" \
"   \`/ossssso+/:-        -:/+osssso+-      \n" \
"  \`+sso+:-\`                 \`.-/+oso:   \n" \
" \`++:.                           \`-/+/   \n" \
" .\`                                 \`/""\033[0m"
#start
step=0
#********************************************************************************************1-inet_test
function inet_test {        
        echo -e "\x1B[32m""The internet, connection test""\x1B[0m"
            echo "Continue?  y/N"
                read var
                    if [ "$var" == "y" ]
                    then
                        var=$(ping -c1 8.8.8.8 | awk '/transmitted/{print $1+$4}')
                        if [ $var  == "2" ]
                        then echo -e "\x1B[32m""The internet, connection ok""\x1B[0m"
                        else echo -e "\x1B[32m""The internet connect error""\x1B[0m"
                             echo -e "\x1B[32m""Please connecting to the internet""\x1B[0m"
                        fi
                    else echo "Skip"
                    fi    
        }
        
#*********************************************************************************************2-parted_disk       
function parted_disk {
        echo -e "\x1B[36m""Parted disk""\x1B[0m"
            echo "Continue?  y/N"
                read var
                    if [ "$var" == "y" ]
                    then
                        echo -e "\x1B[35m""Enter name disk for parted (for example a - sda)""\x1B[0m"
                        read var
                        sudo cfdisk "/dev/"$var
                    else echo "Skip"
                    fi
            }
#********************************************************************************************3-assign_sections
function assign_sections {
        echo -e "\x1B[36m""Assign sections""\x1B[0m"
            echo "Continue? y/N"
                read var
                    if [ "$var" == "y" ]
                    then
                        echo "enter name target disk (sd(a,b,c))"
                        read var
                        d_target="/dev/"$var
                        echo "enter name disk (sd(a,b,c)(1,2,3,4..)) for boot"
                        read var
                        d_boot="/dev/"$var   
                        echo "enter name disk (sd(a,b,c)(1,2,3,4..)) for root"
                        read var
                        d_root="/dev/"$var
                        echo "enter name disk (sd(a,b,c)(1,2,3,4..)) for swap"
                        read var
                        d_swap="/dev/"$var
                        echo "enter name disk (sd(a,b,c)(1,2,3,4..)) for home"
                        read var
                        d_home="/dev/"$var
                        echo "target:"$d_target
                        echo "for boot:"$d_boot
                        echo "for root:"$d_root
                        echo "for swap:"$d_swap
                        echo "for home:"$d_home
                    else echo "Skip"
                    fi
            }
#********************************************************************************************4-formating_disk
function formating_disk {
        echo -e "\x1B[36m""Formating disk""\x1B[0m"
                
            echo "Continue?  y/N"
                read var
                    if [ "$var" == "y" ]
                    then    
                        mkfs.ext2 $d_boot
                        mkfs.ext4 $d_root
                        mkfs.ext4 $d_home
                    else echo "Skip"
                    fi
                lsblk -f
            }
#********************************************************************************************5-mounting_disk
function mounting_disk {        
        echo -e "\x1B[36m""Mounting disk""\x1B[0m"
            echo "Continue?  y/N"
                read var
                    if [ "$var" == "y" ]
                    then
                        mkswap $d_swap
                        swapon $d_swap
                            var=$(lsblk -f $d_root | awk '/sd*/{print $4}')
                            if [ "$var" != "" ]
                            then
                                umount $d_root
                                mount $d_root /mnt
                            else
                                mount $d_root /mnt
                            fi
                        mkdir /mnt/{boot,home}
                        var=$(lsblk -f $d_root | awk '/sd*/{print $4}')
                            if [ "$var" != "" ]
                            then
                                umount $d_boot
                                mount $d_boot /mnt/boot
                            else
                                mount $d_boot /mnt/boot
                            fi
                        var=$(lsblk -f $d_home | awk '/sd*/{print $4}')
                            if [ "$var" != "" ]
                            then
                                umount $d_home
                                mount $d_home /mnt/home
                            else
                                mount $d_home /mnt/home
                            fi
                    else echo "Skip"
                    fi
                lsblk -f
            }
#********************************************************************************************6-edit_mirrorlist
function edit_mirrorlist {
        echo -e "\x1B[36m""Edit mirrorlist""\x1B[0m"      
            echo "Continue? y/N "
                read var 
                if [ "$var" == "y" ]
                then
                     echo   "nano /etc/pacman.d/mirrorlist"
                else echo "Skip"
                fi
            }
  
#********************************************************************************************7-pacman_update
function pacman_update {
        echo -e "\x1B[36m""Update pacman""\x1B[0m"
            echo "Continue?  y/N"
                read var
                    if [ "$var" == "y" ]
                    then
                        pacman -Syy
                    fi
            }
#********************************************************************************************8-istall_base
function istall_base {
        echo -e "\x1B[36m""Install base pakages""\x1B[0m"
            echo "Continue?  y/N"
                read var
                    if [ "$var" == "y" ]
                    then
                        pacstrap /mnt base base-devel
                    else echo "Skip"
                    fi
            }
#********************************************************************************************9-generate_fstab
function generate_fstab {
        echo -e "\x1B[36m""Generate fstab""\x1B[0m"
            echo "Continue?  y/N"
                read var
                    if [ "$var" == "y" ]
                    then
                        genfstab -pU /mnt >> /mnt/etc/fstab
                    else echo "Skip"
                    fi
            }
#********************************************************************************************10-goto_arch_chroot
function goto_arch_chroot {
        echo -e "\x1B[36m""Go in arch-chroot""\x1B[0m"
            echo "Continue?  y/N"
                read var
                    if [ "$var" == "y" ]
                    then
                        arch-chroot /mnt
                    else echo "Skip"
                    fi
            }
#********************************************************************************************11-grub_pkg_install
function grub_pkg_install {
        echo -e "\x1B[36m""Grub install""\x1B[0m"
        echo "Continue?  y/N"
                read var
                    if [ "$var" == "y" ]
                    then
                        pacman -S grub
                    else echo "Skip"
                    fi
            }
#********************************************************************************************12-pakages_install
function pakages_install {
            echo -e "\x1B[36m""Pakages for install""\x1B[0m"
                echo "Continue?  y/N"
                    read var
                        if [ "$var" == "y" ]
                        then
                            echo "Enter pakages name for install "
                            read var
                            pacman -S $var
                        else echo "Skip"
                        fi
            }
#********************************************************************************************13-host_name
function host_name {
            echo -e "\x1B[36m""Edit host name""\x1B[0m"
                echo "Continue?  y/N"
                    read var
                        if [ "$var" == "y" ]
                        then
                            echo "Enter host name:"
                            read var
                            echo $var > /etc/hostname
                        else echo "Skip"
                        fi
            }
#********************************************************************************************14-time_zone
function time_zone {
            echo -e "\x1B[36m""Edit time zone""\x1B[0m"
                echo "Continue?  y/N"
                    read var
                        if [ "$var" == "y" ]
                        then
                            ls /usr/share/zoneinfo/Europe
                            echo "Enter select time_zone"
                            read var
                            ln -s /usr/share/zoneinfo/Europe/$var /etc/localtime
                        else echo "Skip"
                        fi
            }
#********************************************************************************************15-edit_locale
function edit_locale {
        echo -e "\x1B[36m""Edit locale""\x1B[0m"      
            echo "Continue? y/N "
                read var 
                if [ "$var" == "y" ]
                then
                     echo   "uncomment the necessary in locale.gen"
                     read -s -n1 -p $'\x1B[32m press any key to continue \x1B[0m'
                     nano /etc/locale.gen
                     echo   "Enter select locale (for example a - LANG=en_US.UTF-8)"
                     read -s -n1 -p $'\x1B[32m press any key to continue \x1B[0m'
                     nano /etc/locale.conf
                     echo   "nano /etc/locale.gen"
                else echo "Skip"
                fi
            echo "Generate locale, Continue? y/N "
                read var 
                if [ "$var" == "y" ]
                then
                     locale-gen
                else echo "Skip"
                fi
            }
#********************************************************************************************16-create_linux_img
function create_linux_img {
        echo -e "\x1B[36m""Create linux_img""\x1B[0m"
        echo "Continue?  y/N"
                read var
                    if [ "$var" == "y" ]
                    then
                        mkinitcpio -p linux
                    else echo "Skip"
                    fi
            }
#********************************************************************************************17-grub_config
function grub_config {
        echo -e "\x1B[36m""Grub config""\x1B[0m"
        echo "Continue?  y/N"
                read var
                    if [ "$var" == "y" ]
                    then
                        grub-mkconfig -o /boot/grub/grub.cfg
                    else echo "Skip"
                    fi
            }
#********************************************************************************************18-bootloader_installation
function bootloader_installation {
        echo -e "\x1B[36m""Bootloader installation""\x1B[0m"
        echo "Continue?  y/N"
                read var
                    if [ "$var" == "y" ]
                    then
                        grub-install $d_target
                    else echo "Skip"
                    fi
            }
#********************************************************************************************19-create_pass_root
function create_pass_root {
        echo -e "\x1B[36m""Create pass root""\x1B[0m"
        echo "Continue?  y/N"
                read var
                    if [ "$var" == "y" ]
                    then
                        echo "Enter new password for root"
                        passwd
                    else echo "Skip"
                    fi
            }
#********************************************************************************************20-exit_installer
function exit_installer {
        echo -e "\x1B[36m""EXIT""\x1B[0m"
        echo "Continue?  y/N"
                read var
                    if [ "$var" == "y" ]
                    then
                        echo "exit of arch-chroot"
                        exit
                        
                    else echo "Skip"
                    fi
            }
#********************************************************************************************z-dialog_my       
function dialog_my {
        echo -e "\x1B[33m""___Select_menu_item__________""\x1B[0m"
        echo -e "\x1B[36m""1)Continue:""\x1B[0m"${stepn[$(($step+1))]}
        echo -e "\x1B[36m""2)Next:""\x1B[0m"${stepn[$(($step+2))]}
        echo -e "\x1B[36m""3)Repeat:""\x1B[0m"${stepn[$step]} 
        echo -e "\x1B[36m""4)Come back:""\x1B[0m"${stepn[$(($step-1))]}
        echo -e "\x1B[36m""5)return to start""\x1B[0m"
        echo -e "\x1B[31m""6)exit""\x1B[0m"
        read var
        echo -e "\x1B[33m""______________V______________""\x1B[0m"

                if [ "$var" == "1" ]
                then
                    step=$(($step+1))
                    echo -e "\x1B[36m""Continue!""\x1B[0m"
                elif [ "$var" == "2" ]
                then
                    echo -e "\x1B[36m""Skip "${stepn[$(($step+1))]}", Jamp to next!""\x1B[0m"
                    step=$(($step+2))
                elif [ "$var" == "3" ]
                then
                    echo -e "\x1B[36m""Repeat!""\x1B[0m"  
                elif [ "$var" == "4" ]
                then
                    step=$(($step-1))
                    echo -e "\x1B[36m""Come back!""\x1B[0m"
                elif [ "$var" == "5" ]
                then
                    step=0
                    echo -e "\x1B[36m""Back to start!""\x1B[0m"
                elif [ "$var" == "6" ]
                then echo "exit"
                     exit
                fi
            }                   
#********************************************************************************************main
stepn=(
   start
   inet_test
   parted_disk
   assign_sections
   formating_disk
   mounting_disk
   edit_mirrorlist
   pacman_update
   istall_base
   generate_fstab
   goto_arch_chroot
   grub_pkg_install
   pakages_install
   host_name
   time_zone
   edit_locale
   create_linux_img
   grub_config
   bootloader_installation
   create_pass_root
   exit_installer
      )
        
echo -e "\x1B[36m""Wellcome to the ArchLinux""\x1B[0m"
while :
    do
    case $step in
          0  ) echo "The start" ;;
          1  ) inet_test        ;;
          2  ) parted_disk      ;;
          3  ) assign_sections  ;;
          4  ) formating_disk   ;;
          5  ) mounting_disk    ;;
          6  ) edit_mirrorlist  ;;
          7  ) pacman_update    ;;
          8  ) istall_base      ;;
          9  ) generate_fstab   ;;
         10  ) goto_arch_chroot ;;
         11  ) grub_pkg_install ;;
         12  ) pakages_install  ;;
         13  ) host_name        ;;
         14  ) time_zone        ;;
         15  ) edit_locale      ;;
         16  ) create_linux_img ;;
         17  ) grub_config      ;;
         18  ) bootloader_installation ;;
         19  ) create_pass_root ;;
         20  ) exit_installer   ;;
    esac

    read -s -n1 -p $'\x1B[32m press any key to continue\x1B[0m'
    clear
    echo -e "\x1B[33m""__________step____________""\x1B[0m"
    if [ $step -gt 0 ]
    then
    echo "previous step:"${stepn[$(($step-1))]}
    fi
    echo "done     step:"${stepn[$step]}
    echo "next     step:"${stepn[$(($step+1))]}
    echo -e "\x1B[33m""___________^______________""\x1B[0m"
    echo ""
    echo ""
    echo ""
    dialog_my
    done

echo -e "\x1B[36m""********************END****************************""\x1B[0m"        
