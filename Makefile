export PLOTLY_RENDERER=notebook_connected

# MD_DIR_FSharp ?= fsharp
# UNCONV_DIR_FSharp ?= unconverted/fsharp
# IPYNB_DIR_FSharp ?= build/fsharp/ipynb
# HTML_DIR ?= build/fsharp/html
# FAIL_DIR ?= build/fsharp/failures

# MD_FILES := $(shell ls $(MD_DIR_FSharp)/*.md)
# UNCONV_FILES := $(shell ls $(UNCONV_DIR_FSharp)/*.md)

# IPYNB_FILES := $(patsubst $(MD_DIR_FSharp)/%.md,$(IPYNB_DIR_FSharp)/%.ipynb,$(MD_FILES))
# HTML_FILES := $(patsubst $(MD_DIR_FSharp)/%.md,$(HTML_DIR)/2019-07-03-%.html,$(MD_FILES))


# all: $(HTML_FILES)

# .PRECIOUS: $(IPYNB_FILES)

# $(IPYNB_DIR_FSharp)/.mapbox_token: $(MD_DIR_FSharp)/.mapbox_token
# 	@mkdir -p $(IPYNB_DIR_FSharp)
# 	@echo "[symlink]    .mapbox_token"
# 	@cd $(IPYNB_DIR_FSharp) && ln -s ../../$<

# $(IPYNB_FILES): $(IPYNB_DIR_FSharp)/.mapbox_token

# $(IPYNB_DIR_FSharp)/%.ipynb: $(MD_DIR_FSharp)/%.md
# 	@mkdir -p $(IPYNB_DIR_FSharp)
# 	@echo "[jupytext]   $<"
# 	@cat $< what_about_dash.md | jupytext  --to notebook --quiet --output $@

# $(HTML_DIR)/2019-07-03-%.html: $(IPYNB_DIR_FSharp)/%.ipynb
# 	@mkdir -p $(HTML_DIR)
# 	@mkdir -p $(FAIL_DIR)
# 	@echo "[nbconvert]  $<"
# 	@jupyter nbconvert $< --to html --template nb.tpl \
# 			--ExecutePreprocessor.timeout=600\
# 	  	--output-dir $(HTML_DIR) --output 2019-07-03-$*.html \
# 	  	--execute > $(FAIL_DIR)/$* 2>&1  && rm -f $(FAIL_DIR)/$*



MD_DIR_CSharp ?= csharp
UNCONV_DIR_CSharp ?= unconverted/csharp
IPYNB_DIR_CSharp ?= build/csharp/ipynb
HTML_DIR ?= build/csharp/html
FAIL_DIR ?= build/csharp/failures

MD_FILES := $(shell ls $(MD_DIR_CSharp)/*.md)
UNCONV_FILES := $(shell ls $(UNCONV_DIR_CSharp)/*.md)

IPYNB_FILES := $(patsubst $(MD_DIR_CSharp)/%.md,$(IPYNB_DIR_CSharp)/%.ipynb,$(MD_FILES))
HTML_FILES := $(patsubst $(MD_DIR_CSharp)/%.md,$(HTML_DIR)/2019-08-03-%.html,$(MD_FILES))


all: $(HTML_FILES)

.PRECIOUS: $(IPYNB_FILES)

$(IPYNB_DIR_CSharp)/.mapbox_token: $(MD_DIR_CSharp)/.mapbox_token
	@mkdir -p $(IPYNB_DIR_CSharp)
	@echo "[symlink]    .mapbox_token"
	@cd $(IPYNB_DIR_CSharp) && ln -s ../../$<

$(IPYNB_FILES): $(IPYNB_DIR_CSharp)/.mapbox_token

$(IPYNB_DIR_CSharp)/%.ipynb: $(MD_DIR_CSharp)/%.md
	@mkdir -p $(IPYNB_DIR_CSharp)
	@echo "[jupytext]   $<"
	@cat $< what_about_dash.md | jupytext  --to notebook --quiet --output $@

$(HTML_DIR)/2019-08-03-%.html: $(IPYNB_DIR_CSharp)/%.ipynb
	@mkdir -p $(HTML_DIR)
	@mkdir -p $(FAIL_DIR)
	@echo "[nbconvert]  $<"
	@jupyter nbconvert $< --to html --template nb.tpl \
			--ExecutePreprocessor.timeout=600\
	  	--output-dir $(HTML_DIR) --output 2019-08-03-$*.html \
	  	--execute > $(FAIL_DIR)/$* 2>&1  && rm -f $(FAIL_DIR)/$*
