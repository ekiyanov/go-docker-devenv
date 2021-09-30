FROM golang:latest
MAINTAINER Michele Bertasi

ADD fs/ /

# install pagkages
RUN apt-get update                                                      && \
    apt-get install -y ncurses-dev libtolua-dev exuberant-ctags unzip   && \
    ln -s /usr/include/lua5.2/ /usr/include/lua                         && \
    ln -s /usr/lib/x86_64-linux-gnu/liblua5.2.so /usr/lib/liblua.so     && \
		apt-get install -y libssl1.1 libssl-dev build-essential cmake zsh 	&& \
# cleanup
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install seabolt for neo4j
RUN cd /tmp 																														&& \
		wget https://github.com/neo4j-drivers/seabolt/archive/v1.7.4.zip 		&& \
		unzip v1.7.4.zip 																										&& \
		cd seabolt-1.7.4																										&& \
		bash ./make_release.sh																							&& \
		cd build && make install  && cp ./bin/* /usr/bin -r									&& \
		cp ./lib/* /usr/lib -r && cp ./share/* /usr/share -r 								&& \
		cp ./include/* /usr/include -r && cp ./dist/* /usr -r	

# install zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install protoc
RUN cd /tmp && curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v3.18.0/protoc-3.18.0-linux-x86_64.zip && unzip protoc-3.18.0-linux-x86_64.zip -d /usr/local && chmod +x /usr/local/bin/protoc

# build and install vim
RUN cd /tmp                                                             && \
    git clone --depth 1 https://github.com/vim/vim.git                  && \
    cd vim                                                              && \
    ./configure --with-features=huge --enable-luainterp                    \
        --enable-gui=no --without-x --prefix=/usr                       && \
    make VIMRUNTIMEDIR=/usr/share/vim/vim82                             && \
    make install                                                        && \
# cleanup
    rm -rf /tmp/* /var/tmp/*

# get go tools
RUN go get golang.org/x/tools/cmd/godoc                                 && \
    go get github.com/nsf/gocode                                        && \
    go get golang.org/x/tools/cmd/goimports                             && \
    go get github.com/rogpeppe/godef                                    && \
    go get golang.org/x/tools/cmd/gorename                              && \
    go get golang.org/x/lint/golint                                     && \
    go get github.com/kisielk/errcheck                                  && \
    go get github.com/jstemmer/gotags                                   && \
    go get github.com/tools/godep                                       && \
    GO111MODULE=on go get golang.org/x/tools/gopls@latest               && \
    mv /go/bin/* /usr/local/go/bin                                      && \
# cleanup
    rm -rf /go/src/* /go/pkg

# add dev user
RUN adduser dev --disabled-password --gecos ""                          && \
    echo "ALL            ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers     && \
    chown -R dev:dev /home/dev /go

USER dev
ENV HOME /home/dev

# install vim plugins
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    vim +PlugInstall +qall

# install grpc and grpc-gateway generators
RUN go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@v2.6.0
RUN go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@v2.6.0

# protoc-gen-go-grpc install protoc-gen-go
# RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.27 
#RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.23
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.26
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.1

#RUN GOPROXY=http://172.17.0.1:8888,direct go get -u -v \
#    github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway \
#    github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger \
#    github.com/golang/protobuf/protoc-gen-go


RUN yes | sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN go get github.com/go-delve/delve/cmd/dlv

RUN vim +GoInstallBinaries +qall

# Install swagger generator
RUN cd /tmp && git clone --depth=1 https://github.com/go-swagger/go-swagger && \
    cd /tmp/go-swagger/cmd/swagger && go install

COPY cheatsheet.md /etc/motd

CMD /usr/bin/zsh

