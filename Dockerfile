FROM python:3.11-bookworm as builder-image

COPY install/requirements_py3.11.txt .
RUN pip3 install -U pip
RUN pip3 install --no-cache-dir -r requirements_py3.11.txt

FROM python:3.11-slim-bookworm

COPY --from=builder-image /usr/local/bin /usr/local/bin
COPY --from=builder-image /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
  procps \
  xz-utils && \
  rm -rf /var/lib/apt/lists/*


WORKDIR /vdb_bench
#COPY . .
ENV PYTHONPATH /vdb_bench

# ENTRYPOINT ["python3", "-m", "vectordb_bench"]
ENTRYPOINT ["/usr/bin/bash"]
