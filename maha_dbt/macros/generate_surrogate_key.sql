{% macro generate_surrogate_key(column_list) %}
    md5(
        concat_ws('|',
            {% for col in column_list %}
                cast({{ col }} as string)
                {%- if not loop.last %}, {% endif %}
            {% endfor %}
        )
    )
{% endmacro %}
