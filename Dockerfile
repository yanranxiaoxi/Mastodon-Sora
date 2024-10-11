FROM docker.io/tootsuite/mastodon:v4.3.0

ENV GITHUB_REPOSITORY=yanranxiaoxi/Mastodon-Sora
ENV MASTODON_VERSION_METADATA=sora

# COPY --chown=991:991 ./icons /opt/mastodon/app/javascript/icons
# COPY --chown=991:991 ./images /opt/mastodon/app/javascript/images

RUN echo "全文搜索中文优化" && \
	sed -i "/verbatim/,/}/{s|standard|ik_max_word|}" /opt/mastodon/app/chewy/accounts_index.rb && \
	sed -i "s|analyzer: {|char_filter: {\n      tsconvert: {\n        type: 'stconvert',\n        keep_both: false,\n        delimiter: '#',\n        convert_type: 't2s',\n      },\n    },\n\n    analyzer: {|" /opt/mastodon/app/chewy/{statuses_index,public_statuses_index,tags_index}.rb && \
	sed -i "/content/,/}/{s|standard'|ik_max_word',\n        char_filter: %w(tsconvert)|}" /opt/mastodon/app/chewy/{statuses_index,public_statuses_index}.rb && \
	sed -i "s|keyword'|ik_smart',\n        char_filter: %w(tsconvert)|" /opt/mastodon/app/chewy/tags_index.rb && \
	echo "修改版本输出样式" && \
	sed -i "/to_s/,/repository/{s|+|~|}" /opt/mastodon/lib/mastodon/version.rb && \
	echo "重新编译资源文件" && \
	OTP_SECRET=precompile_placeholder SECRET_KEY_BASE=precompile_placeholder rails assets:precompile && \
	yarn cache clean
