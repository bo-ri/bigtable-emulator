FROM google/cloud-sdk:alpine

RUN apk update && apk add vim

RUN gcloud components update beta
# install emulator
RUN gcloud components install beta
# install cbt command
RUN gcloud components install cbt
# write project settings in ~/.cbtrc
RUN echo project = "\"sample_project\"" > /root/.cbtrc
RUN echo instance = "\"sample\"" >> /root/.cbtrc
RUN echo creds = "\"credentials\"" >> /root/.cbtrc
# write bigtable exec file
RUN echo command1="\"gcloud --quiet beta emulators bigtable start --host-port localhost:8086 &\"" > /root/bigtable.sh
RUN echo eval $command1 >> /root/bigtable.sh
RUN echo command2="\"\$(gcloud beta emulators bigtable env-init)\"" >> /root/bigtable.sh
#RUN echo eval $command1 >> /root/bigtable.sh
RUN echo eval $command2 >> /root/bigtable.sh
RUN chmod 777 /root/bigtable.sh

EXPOSE 8086

# ENTRYPOINT ["gcloud", "--quiet", "beta", "emulators", "bigtable"]
# CMD ["start", "--host-port", "localhost:8086"]
#ENTRYPOINT ["sh", "-c", "/root/bigtable.sh"]


# docker run -it -p 8086:8086 [image name]
#$(gcloud beta emulators bigtable env-init)
# command1="gcloud beta emulators bigtable start --host-port localhost:8086 &"
# command2="$(gcloud beta emulators bigtable env-init)"
# eval $command1
# eval $command2
