FROM ollama-base:latest

COPY scripts/start.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/start.sh
RUN mkdir -p /root/.ollama

RUN ollama serve & \
  SERVER_PID=$! && \
  sleep 5 && \
  ollama pull deepseek-coder:latest & \
  ollama pull gpt-oss:20b & \
  ollama pull llama3.2 & \
  ollama pull qwen2.5:7b & \
  kill $SERVER_PID && \
  sleep 2

EXPOSE 11434

CMD ["/usr/local/bin/start.sh"]
