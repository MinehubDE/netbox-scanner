FROM python:slim AS builder

COPY requirements.txt .

RUN python3 -m venv venv && \
	./venv/bin/pip install pip -U && \
	./venv/bin/pip install -r requirements.txt -U

FROM python:slim AS netbox-scanner

COPY --from=builder venv venv

RUN apt-get update && apt-get -y install nmap --no-install-recommends && \
	rm -rf /var/lib/apt/lists/* && \
	groupadd --gid 17386 netbox-scanner && \
	useradd --uid 17386 --gid netbox-scanner --home-dir /data --create-home --system netbox-scanner

USER netbox-scanner

WORKDIR /app

COPY --chown=netbox-scanner:netbox-scanner . .

ENTRYPOINT ["/app/entrypoint.sh"]
