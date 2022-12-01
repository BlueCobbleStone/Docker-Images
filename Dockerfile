FROM kasmweb/core-ubuntu-jammy:1.11.0
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########
RUN apt update && apt install -y curl wget arc-theme software-properties-common xdotool \
    && add-apt-repository ppa:kubuntu-ppa/backports \
    && apt update \
    && apt install -y kmines
    
####Run the App maximized######
RUN mkdir -p /home/kasm-user/.config/autostart/ \
    && cp /usr/share/applications/org.kde.kmines.desktop /home/kasm-user/.config/autostart/org.kde.kmines.desktop \
    && chmod +x /home/kasm-user/.config/autostart/org.kde.kmines.desktop \
    && echo "/usr/games/kmines &" >> /home/kasm-user/.config/kmines-start.sh \
    && echo "sleep 5" >> /home/kasm-user/.config/kmines-start.sh  \
    && echo "xdotool key Alt+F10" >> /home/kasm-user/.config/kmines-start.sh  \
    && chmod +x /home/kasm-user/.config/kmines-start.sh \
    && sed -i '/Exec=/c\Exec=/home/kasm-user/.config/kmines-start.sh ' /home/kasm-user/.config/autostart/org.kde.kmines.desktop 

####Add desktop file to Desktop######
RUN echo "cp /home/kasm-user/.config/autostart/org.kde.kmines.desktop /home/kasm-user/Desktop/org.kde.kmines.desktop " >> $STARTUPDIR/custom_startup.sh \
    && echo "chmod +x /home/kasm-user/Desktop/org.kde.kmines.desktop " >> $STARTUPDIR/custom_startup.sh \
    && echo "rm /home/kasm-user/Desktop/Downloads" >> $STARTUPDIR/custom_startup.sh \
    && echo "rm /home/kasm-user/Desktop/Uploads" >> $STARTUPDIR/custom_startup.sh \
    && echo "sleep infinity" >> $STARTUPDIR/custom_startup.sh \
    && chmod +x $STARTUPDIR/custom_startup.sh \
    && chown -R 1000:1000 /home/kasm-user/.config/

###Set Xfce Dark Theme #######
COPY ./xsettings.xml /home/kasm-default-profile/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME
ENV HOME /home/kasm-user
WORKDIR $HOME

RUN mkdir -p $HOME && chown -R 1000:0 $HOME
#### Set Qt Dark Theme ######
USER 1000