
# Must add platform for macOS M1 Pro Max, otherwise the platform is arm64
FROM --platform=linux/amd64 ubuntu:20.04 as base

FROM base as builder
RUN apt-get update && \
    apt-get install -y make jq curl wget zip unzip bash bash-completion git bsdmainutils

# Install AWS CLI
WORKDIR /tmp/
RUN curl -L -o install-aws.sh https://raw.githubusercontent.com/unfor19/install-aws-cli-action/master/entrypoint.sh && \
    chmod +x install-aws.sh && \
    ./install-aws.sh "v2" "amd64" && \
    rm install-aws.sh

ARG TERRAFORM_VERSION="1.2.5"
RUN curl -L -o terraform${TERRAFORM_VERSION}.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform${TERRAFORM_VERSION}.zip && \
    cp terraform /usr/local/bin/terraform && \
    mv terraform /usr/local/bin/terraform${TERRAFORM_VERSION} && \
    chmod +x /usr/local/bin/terraform /usr/local/bin/terraform${TERRAFORM_VERSION} && \
    rm terraform${TERRAFORM_VERSION}.zip

# Add auto completion
RUN curl -L https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash && \
    echo "source ~/.git-completion.bash" >> ~/.bashrc && \
    echo "source /etc/profile.d/bash_completion.sh" >> ~/.bashrc

ENTRYPOINT [ "bash" ]
