# have to use the literal exec path because the original binary was overwritten while getting
# tikz integration (sigh)
serve:
	open http://127.0.0.1:4000/
	/usr/local/Cellar/ruby/2.5.1/lib/ruby/gems/2.5.0/gems/bundler-1.16.1/exe/bundle exec jekyll serve
