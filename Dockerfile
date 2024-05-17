FROM docker.io/tootsuite/mastodon:v4.2.8

ENV GITHUB_REPOSITORY yanranxiaoxi/Mastodon-Sora
ENV MASTODON_VERSION_METADATA sora

# COPY --chown=991:991 ./icons /opt/mastodon/app/javascript/icons
COPY --chown=991:991 ./images /opt/mastodon/app/javascript/images

RUN echo "修改字数上限" && \
	sed -i "s|MAX_CHARS = 500|MAX_CHARS = 20000|" /opt/mastodon/app/validators/status_length_validator.rb && \
	sed -i "s|length(fulltext) > 500|length(fulltext) > 20000|" /opt/mastodon/app/javascript/mastodon/features/compose/components/compose_form.jsx && \
	sed -i "s|CharacterCounter max={500}|CharacterCounter max={20000}|" /opt/mastodon/app/javascript/mastodon/features/compose/components/compose_form.jsx && \
	echo "修改媒体上限" && \
	sed -i "s|pixels: 8_294_400|pixels: 33_177_600|" /opt/mastodon/app/models/media_attachment.rb && \
	sed -i "s|IMAGE_LIMIT = 16|IMAGE_LIMIT = 32|" /opt/mastodon/app/models/media_attachment.rb && \
	sed -i "s|VIDEO_LIMIT = 99|VIDEO_LIMIT = 100|" /opt/mastodon/app/models/media_attachment.rb && \
	echo "修改投票上限" && \
	sed -i "s|options.size >= 4|options.size >= 16|" /opt/mastodon/app/javascript/mastodon/features/compose/components/poll_form.jsx && \
	sed -i "s|MAX_OPTIONS      = 4|MAX_OPTIONS      = 16|" /opt/mastodon/app/validators/poll_validator.rb && \
	echo "全文搜索中文优化" && \
	sed -i "/verbatim/,/}/{s|standard|ik_max_word|}" /opt/mastodon/app/chewy/accounts_index.rb && \
	sed -i "s|analyzer: {|char_filter: {\n      tsconvert: {\n        type: 'stconvert',\n        keep_both: false,\n        delimiter: '#',\n        convert_type: 't2s',\n      },\n    },\n\n    analyzer: {|" /opt/mastodon/app/chewy/{statuses_index,public_statuses_index,tags_index}.rb && \
	sed -i "/content/,/}/{s|standard'|ik_max_word',\n        char_filter: %w(tsconvert)|}" /opt/mastodon/app/chewy/{statuses_index,public_statuses_index}.rb && \
	sed -i "s|keyword'|ik_smart',\n        char_filter: %w(tsconvert)|" /opt/mastodon/app/chewy/tags_index.rb && \
	echo "修改版本输出样式" && \
	sed -i "/to_s/,/repository/{s|+|~|}" /opt/mastodon/lib/mastodon/version.rb && \
	echo "重新编译资源文件" && \
	OTP_SECRET=precompile_placeholder SECRET_KEY_BASE=precompile_placeholder rails assets:precompile && \
	yarn cache clean
