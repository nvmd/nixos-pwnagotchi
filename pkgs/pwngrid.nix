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
  version = "unstable-20240729";

  src = fetchFromGitHub { # https://github.com/jayofelony/pwngrid.git
    owner = "jayofelony";
    repo = "pwngrid";
    rev = "0f2e77c8a748957c65862537b4d2e2d6f46097fa";
    hash = "sha256-PPMXmYb0h2F97izJTLF3KkGGMdYiNinVhZcRzdjZ8Sg=";
  };

  vendorHash = "sha256-9M2+LZJ/ztlsNJ9q5bS+5gnmU4HX/zUQKM1VlSPqzGE=";

  ldflags = [ "-w -s" ];

  buildInputs = [ libpcap ];

  meta = with lib; {
    description = "PwnGRID, (⌐■_■) - API server for pwnagotchi.ai";
    homepage = "https://github.com/jayofelony/pwngrid";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ kazenyuk ];
  };
}