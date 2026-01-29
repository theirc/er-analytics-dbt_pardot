with visitor_activity as (
    select *
    from {{ ref('stg_pardot__visitor_activity') }}
),

campaigns as (
    select *
    from {{ ref('stg_pardot__campaign') }}
),

list_emails as (
    select *
    from {{ ref('stg_pardot__list_email') }}
)

select 
    visitor_activity.*,
    
    /*basics */
    list_email_sent_at,
    list_email_name,
    list_email_subject,
    
    /* parsed dimensions from list email name generated via the URL builder*/
    list_email_fiscal_year,
    list_email_month_abbreviated,
    list_email_version_number,
    list_email_audience_segment_code,
    list_email_audience_segment_name,
    list_email_test_variant,
    list_email_type,

    /* flags and keys */
    is_list_email_url_builder_format,
    list_email_name_internal_id,
    list_email_natural_key,


    /* An email specific URL builder was rolled out globally in late FY25, with full adoption across markets from FY26. See https://theirc.github.io/URLBuilder/#emailUrlGenPage . 
    New attributes from the URL builder created on stg_pardot__list_email and passed through below */
    email_url_builder_month_abbreviated,
    email_url_builder_month_full_name,
    email_url_builder_version_number,
    email_url_builder_audience_segment_code,
    email_url_builder_audience_segment_name,
    email_url_builder_test_variant,
    is_email_url_builder_format,

    
    campaigns.campaign_name as activity_campaign_name 

from visitor_activity

left join campaigns on visitor_activity.campaign_id = campaigns.campaign_id

left join list_emails on visitor_activity.list_email_id = list_emails.list_email_id

