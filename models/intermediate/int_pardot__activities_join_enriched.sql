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
    
    is_mmus_formated_list_email_name,
    list_email_natural_key,
    list_email_sent_at,
    list_email_keyword_segment,
    list_email_keyword_status,
    list_email_keyword_type,
    list_email_name_parsed_topic,

    list_email_name,
    list_email_subject,

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

