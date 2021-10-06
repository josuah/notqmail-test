GIT = https://github.com/notqmail/notqmail
SHA = $$(git -C notqmail.git rev-parse ${BRANCH})

all:v notqmail.git
	@ls test | sed 's/.sh$$//' |\
	 xargs -I {} -n 1 make one BRANCH=${BRANCH} TEST={}

one:v notqmail.git
	@make log/${SHA}-${TEST}.log COMMIT=${SHA} TEST=${TEST}

log/${COMMIT}-${TEST}.log: notqmail-${COMMIT}
	@echo testing $@
	@-make test COMMIT=${COMMIT} TEST=${TEST} >$@.tmp 2>&1
	@mv $@.tmp $@

test:v notqmail-${COMMIT}
	rm -rf notqmail-${COMMIT}/root
	mkdir -p notqmail-${COMMIT}/root
	make -C notqmail-${COMMIT} setup
	cd notqmail-${COMMIT}/root &&\
	 PATH="$$PWD/bin:$$PATH" sh -eux ../../test/${TEST}.sh;\
	 echo exit $?

notqmail-${COMMIT}: notqmail.git
	git -C notqmail.git fetch origin ${COMMIT}
	git -C notqmail.git archive --prefix=$@/ ${COMMIT} | tar xf -
	echo $$PWD/$@/root >$@/conf-qmail
	cp conf-* $@
	make -C $@ it

notqmail.git:
	git clone --bare ${GIT} $@

clean:v
	rm -rf notqmail-*/ log/*.log

v: # virtual target
