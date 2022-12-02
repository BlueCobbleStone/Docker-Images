FROM ubuntu:jammy
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y git qpdf cmake graphicsmagick gcc build-essential pkg-config libqpdf-dev libmagick++-dev qtbase5-dev libqt5svg5-dev qttools5-dev
WORKDIR /root
COPY ./pdfmixtool.sh ./pdfmixtool.sh
RUN bash pdfmixtool.sh
FROM kasmweb/core-ubuntu-jammy:1.11.0
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########
RUN apt update && apt install -y curl wget arc-theme libqt5gui5 libmagick++-6.q16-8 libqt5xml5 libqpdf28 qt5ct xdotool
# Copy and install pdfmixtool compiled files
COPY --from=0 /usr/bin/pdfmixtool /usr/bin/pdfmixtool
COPY --from=0 /usr/share/applications/eu.scarpetta.PDFMixTool.desktop /usr/share/applications/eu.scarpetta.PDFMixTool.desktop
COPY --from=0 /usr/share/icons/hicolor/ /usr/share/icons/hicolor/
####Run the App maximized######
RUN mkdir -p /home/kasm-user/.config/autostart/ \
    && cp /usr/share/applications/eu.scarpetta.PDFMixTool.desktop /home/kasm-user/.config/autostart/eu.scarpetta.PDFMixTool.desktop \
    && chmod +x /home/kasm-user/.config/autostart/eu.scarpetta.PDFMixTool.desktop \
    && echo "pdfmixtool &" >> /home/kasm-user/.config/pdfmixtool-start.sh \
    && echo "sleep 3" >> /home/kasm-user/.config/pdfmixtool-start.sh  \
    && echo "xdotool key Alt+F10" >> /home/kasm-user/.config/pdfmixtool-start.sh  \
    && chmod +x /home/kasm-user/.config/pdfmixtool-start.sh \
    && sed -i '/Exec=/c\Exec=/home/kasm-user/.config/pdfmixtool-start.sh ' /home/kasm-user/.config/autostart/eu.scarpetta.PDFMixTool.desktop 

####Add desktop file to Desktop######
RUN echo "cp /home/kasm-user/.config/autostart/eu.scarpetta.PDFMixTool.desktop /home/kasm-user/Desktop/eu.scarpetta.PDFMixTool.desktop " >> $STARTUPDIR/custom_startup.sh \
    && echo "chmod +x /home/kasm-user/Desktop/eu.scarpetta.PDFMixTool.desktop " >> $STARTUPDIR/custom_startup.sh \
    && echo "rm /home/kasm-user/Desktop/Downloads" >> $STARTUPDIR/custom_startup.sh \
    && echo "rm /home/kasm-user/Desktop/Uploads" >> $STARTUPDIR/custom_startup.sh \
    && echo "sleep infinity" >> $STARTUPDIR/custom_startup.sh \
    && chmod +x $STARTUPDIR/custom_startup.sh

###Set Xfce Dark Theme #######
COPY ./xsettings.xml /home/kasm-default-profile/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
RUN mkdir -p /home/kasm-user/.config/qt5ct
COPY ./qt5ct.conf /home/kasm-user/.config/qt5ct/qt5ct.conf
RUN chown -R 1000:1000 /home/kasm-user/.config/
######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME
ENV HOME /home/kasm-user
WORKDIR $HOME

RUN mkdir -p $HOME && chown -R 1000:0 $HOME
USER 1000
ENV QT_QPA_PLATFORMTHEME qt5ct
