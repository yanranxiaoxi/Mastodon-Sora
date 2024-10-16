FROM docker.io/tootsuite/mastodon:v4.3.0

ENV GITHUB_REPOSITORY=yanranxiaoxi/Mastodon-Sora
ENV MASTODON_VERSION_METADATA=sora

COPY --chown=991:991 ./app /opt/mastodon/app
COPY --chown=991:991 ./lib /opt/mastodon/lib

RUN echo "重新编译资源文件" && \
	OTP_SECRET=precompile_placeholder SECRET_KEY_BASE=precompile_placeholder rails assets:precompile && \
	yarn cache clean
