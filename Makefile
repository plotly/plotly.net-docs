
export PLOTLY_RENDERER=notebook_connected

MD_DIR ?= fsharp
UNCONV_DIR ?= unconverted/fsharp
IPYNB_DIR ?= build/ipynb
HTML_DIR ?= build/html
FAIL_DIR ?= build/failures

MD_FILES := $(shell ls $(MD_DIR)/*.md)
UNCONV_FILES := $(shell ls $(UNCONV_DIR)/*.md)

IPYNB_FILES := $(patsubst $(MD_DIR)/%.md,$(IPYNB_DIR)/%.ipynb,$(MD_FILES))
HTML_FILES := $(patsubst $(MD_DIR)/%.md,$(HTML_DIR)/2019-07-03-%.html,$(MD_FILES))


all: $(HTML_FILES)

.PRECIOUS: $(IPYNB_FILES)

$(IPYNB_DIR)/.mapbox_token: $(MD_DIR)/.mapbox_token
	@mkdir -p $(IPYNB_DIR)
	@echo "[symlink]    .mapbox_token"
	@cd $(IPYNB_DIR) && ln -s ../../$<

$(IPYNB_FILES): $(IPYNB_DIR)/.mapbox_token

$(IPYNB_DIR)/%.ipynb: $(MD_DIR)/%.md
	@mkdir -p $(IPYNB_DIR)
	@echo "[jupytext]   $<"
	@cat $< what_about_dash.md | jupytext  --to notebook --quiet --output $@

$(HTML_DIR)/2019-07-03-%.html: $(IPYNB_DIR)/%.ipynb
	@mkdir -p $(HTML_DIR)
	@mkdir -p $(FAIL_DIR)
	@echo "[nbconvert]  $<"
	@jupyter nbconvert $< --to html --template nb.tpl \
			--ExecutePreprocessor.timeout=600\
	  	--output-dir $(HTML_DIR) --output 2019-07-03-$*.html \
	  	--execute > $(FAIL_DIR)/$* 2>&1  && rm -f $(FAIL_DIR)/$*

