# Continuwuity Matrix homeserver for Railway.
# Official image (GitHub mirror of forgejo.ellis.link/continuwuation/continuwuity, same digest).
FROM ghcr.io/continuwuity/continuwuity:v26.9.4@sha256:5f21a556290df5b6eda30c7d695288f5c4b06f9529a64e2cae040297287496c3

# Fixed settings. Any of them can be overridden with a Railway variable of the same name.
# The image is built FROM scratch (no shell), so configuration is environment-only.
# DB_POOL_WORKERS_LIMIT and ROCKSDB_PARALLELISM_THREADS keep the thread count small: by default
# Continuwuity sizes its database pool from the host's NVMe queues (up to 1024 threads), and on
# Railway's large hosts it fails to start with "Resource temporarily unavailable (os error 11)".
ENV CONTINUWUITY_ADDRESS='["::"]' \
    CONTINUWUITY_PORT=8008 \
    CONTINUWUITY_DATABASE_PATH=/var/lib/continuwuity \
    CONTINUWUITY_ALLOW_REGISTRATION=true \
    CONTINUWUITY_ALLOW_FEDERATION=true \
    CONTINUWUITY_TRUSTED_SERVERS='["matrix.org"]' \
    CONTINUWUITY_REQUEST_IP_SOURCE=x_forwarded_for \
    CONTINUWUITY_DB_POOL_AFFINITY=false \
    CONTINUWUITY_DB_POOL_WORKERS=32 \
    CONTINUWUITY_DB_POOL_WORKERS_LIMIT=1 \
    CONTINUWUITY_ROCKSDB_PARALLELISM_THREADS=4

EXPOSE 8008
CMD ["/sbin/conduwuit"]
