FROM ruby

RUN gem install github-pages jekyll-feed jekyll-redirect-from jekyll-seo-tag jekyll-sitemap jekyll-avatar jemoji jekyll-mentions jekyll-include-cache

WORKDIR /usr/src/app

EXPOSE 4000 80
CMD jekyll serve -d /_site --watch --force_polling -H 0.0.0.0 -P 4000
