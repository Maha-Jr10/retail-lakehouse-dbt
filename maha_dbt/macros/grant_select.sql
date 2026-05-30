{% macro grant_select(role=env_var('DBT_GRANTS_ROLE', '')) %}
    {% if target.name == 'prod' and role != '' %}
        {% set grant_sql %}
            GRANT SELECT ON {{ this }} TO `{{ role }}`
        {% endset %}
        {% do run_query(grant_sql) %}
        {{ log('Granted SELECT on ' ~ this ~ ' to ' ~ role, info=True) }}
    {% elif target.name == 'prod' and role == '' %}
        {{ log('Skipping grant — DBT_GRANTS_ROLE not set', info=True) }}
    {% endif %}
{% endmacro %}
