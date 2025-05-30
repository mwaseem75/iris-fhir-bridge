ARG ARG IMAGE=intersystemsdc/irishealth-community:preview
FROM $IMAGE as builder


#WORKDIR /home/irisowner/irisdev
WORKDIR /opt/irisapp
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp

COPY src src
COPY module.xml module.xml

# run iris and initial 
RUN --mount=type=bind,src=.,dst=. \
    iris start IRIS && \
	iris session IRIS < iris.script && \
    iris stop IRIS quietly
    
FROM $IMAGE as final


ADD --chown=${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} https://github.com/grongierisc/iris-docker-multi-stage-script/releases/latest/download/copy-data.py /irisdev/app/copy-data.py

RUN --mount=type=bind,source=/,target=/builder/root,from=builder \
    cp -f /builder/root/usr/irissys/iris.cpf /usr/irissys/iris.cpf && \
    python3 /irisdev/app/copy-data.py -c /usr/irissys/iris.cpf -d /builder/root/ 
    
COPY --from=builder /opt/irisapp/src/data /opt/irisapp/data

# Set ownership and permissions as root, then switch to non-root user
USER root
RUN chown -R ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp/data && \
    chmod -R 755 /opt/irisapp/data
USER ${ISC_PACKAGE_MGRUSER}