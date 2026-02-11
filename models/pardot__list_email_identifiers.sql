    -- This model identifies unique list email entries based on a natural key and aggregates relevant information for data quality and reporting purposes, within Power BI. It also flags potential duplicates for further investigation.
    select
        list_email_natural_key,

        /* Catching potential cases where there are multiple emails with the same natural key, using listagg to show all values within Power BI reporting for data quality purposes */
        listagg(distinct list_email_name, ', ') as list_email_name,
        listagg(distinct list_email_subject, ', ') as list_email_subject,
        listagg(distinct list_email_type, ', ') as list_email_type,

        /*Catching potential cases where there are multiple emails with the same natural key that were sent at different times - for data quality / tracking purposes */
        min(list_email_sent_at) as first_list_email_sent_at,
        max(list_email_sent_at) as last_list_email_sent_at, 

        /*counts */
        count(*) as count_list_email_entries,
        case when count_list_email_entries > 1 then true else false end as has_duplicate_list_email_entries
        
    from {{ ref('stg_pardot__list_email') }}
    where list_email_natural_key is not null
    group by
        list_email_natural_key