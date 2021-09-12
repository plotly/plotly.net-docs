{%- extends 'basic.tpl' -%}
{%- block header -%}
---
{% for k in nb.metadata.get("plotly") -%}
{{ k }}: {{ nb.metadata.get("plotly")[k] }}
{% endfor -%}
---
{{ super() }}
{{ '{% raw %}' }}
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/require.js/2.3.2/require.js"></script>

{%- endblock header-%}

{% block input_group %}
    {%- if not cell.metadata.get('hide_code', False) -%}
        {{ super() }}
    {%- endif -%}
{% endblock input_group %}

{%- block footer %}
{{ super() }}
{{ '{% endraw %}' }}
{%- endblock footer-%}
