{ lib, fetchFromGitHub, buildGoModule, libpcap }:

  #     pwngrid:
  #       source: "https://github.com/jayofelony/pwngrid.git"
  #       url: "https://github.com/jayofelony/pwngrid/releases/download/v1.10.5/pwngrid-1.10.5-aarch64.zip"
  # - name: Install go-1.21
  #   unarchive:
  #     src: https://go.dev/dl/go1.22.3.linux-arm64.tar.gz
  #     dest: /usr/local
  #     remote_src: yes
  #   register: golang

  # - name: Update .bashrc for go-1.21
  #   blockinfile:
  #     dest: /etc/profile
  #     state: present
  #     block: |
  #       export GOPATH=$HOME/go
  #       export PATH=/usr/local/go/bin:$PATH:$GOPATH/bin
  #   when: golang.changed

  # - name: download pwngrid
  #   git:
  #     repo: "{{ packages.pwngrid.source }}"
  #     dest: /usr/local/src/pwngrid

  # - name: install pwngrid
  #   shell: "export GOPATH=$HOME/go && export PATH=/usr/local/go/bin:$PATH:$GOPATH/bin && go mod tidy && make && make install"
  #   args:
  #     executable: /bin/bash
  #     chdir: /usr/local/src/pwngrid

buildGoModule rec {
  pname = "pwngrid";
  version = "1.11.1";

  src = fetchFromGitHub { # https://github.com/jayofelony/pwngrid.git
    owner = "jayofelony";
    repo = "pwngrid";
    rev = "v${version}";
    hash = "sha256-KoqS+NyZ4u6ynhumoFxXGCflEmxbfVfZtTvESW6PaN8=";
  };

  vendorHash = "sha256-mF9CWKDuyp1a/niRqsNilF5IWd6z4pIMBkt5j87edCo=";

  ldflags = [ "-w -s" ];

  buildInputs = [ libpcap ];

  meta = with lib; {
    description = "PwnGRID, (⌐■_■) - API server for pwnagotchi.ai";
    homepage = "https://github.com/jayofelony/pwngrid";
    license = licenses.mit;
    maintainers = with maintainers; [ kazenyuk ];
  };
}