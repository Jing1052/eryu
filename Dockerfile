FROM python:3.12-slim
WORKDIR /app
COPY server/ server/
COPY client/ client/
ENV PORT=9090 \
    DATA_DIR=/app/data
EXPOSE 9090
CMD ["python3", "server/eryu.py"]
