
FROM tomcat:8-jre8
RUN rm -rf /usr/local/tomcat/webapps/*
RUN cd /var/lib/jenkins/workspace/k8s-project/target
COPY vprofile-v1.war /usr/local/tomcat/webapps/
EXPOSE 8080
CMD ["catalina.sh","run"]
