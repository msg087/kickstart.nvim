---
title: New filter
sidebar: hide
showQueries: false
hide_toc: false
queries:
  - new_agg.sql
  - new_agg_n_prev.sql
---


{@partial "new_donor_filters_with_queries.md"}
{@partial "chart_script.md"}

## test filters




```sql bar_data
    SELECT
      *
      from ${new_agg}
```


```sql n_prev_keys
select distinct n_prev_campaigns
from ${new_agg_n_prev}
where n_prev_campaigns is not null

```

```sql y_limits_n_prev
with metric_values as (
  select
    campaign_type_name,
    'pct_donations'     as metric,
    pct_donations       as value
  from ${new_agg_n_prev}

  union all

  select
    campaign_type_name,
    'pct_apts'          as metric,
    pct_apts            as value
  from ${new_agg_n_prev}

  union all

  select
    campaign_type_name,
    'pct_apts_created'  as metric,
    pct_apts_created    as value
  from ${new_agg_n_prev}

  union all

  select
    campaign_type_name,
    'adjusted_total_donations' as metric,
    adjusted_total_donations as value
  from ${new_agg_n_prev}
)

select
  campaign_type_name,
  metric,
  0.0 as y_min,
  case when metric = 'adjusted_total_donations' then ceil(max(value)) else ceil(max(value) * 100) / 100 end as y_max
from metric_values
group by campaign_type_name, metric

```

## Daily Metrics Over Time

<Tabs id="main-tabs">

{#each metrics as m}

  <Tab label={m.label}>

  <Tabs id="sub-tabs">
    <Tab label="Overall Year Metrics">

      {#each final_filtered_c_types as ct}
      ### {ct.campaign_type_name}

        <Grid cols=2>
          {#each years as yr}

           <LineChart
              data={bar_data.where(
                `campaign_type_name = '${ct.campaign_type_name}'
                 and year = ${yr}
           `
              )}
              title={`${yr} `}
              x=day_of_campaign
              y={m.col}
              yFmt="0.00%"
              series=campaign_treatment
              type=line
              xLabel="Day of Campaign"
              yMin=0.0
              echartsOptions={baseEchartsOptions}
              seriesColors={seriesColors}
              chartAreaHeight=300
              connectGroup={`${m.col}-group`}
          >

            <ReferenceLine x={0} label="Campaign Start" hideValue=true/>
           </LineChart>

           {/each}

         </Grid>

       {/each}

  </Tab>

  </Tabs>

</Tab>
  {/each}





</Tabs>



### n_prev_campaigns


<Tabs id="prev">
{#each metrics as m}

<Tab label={m.label}>

  <Tabs id="sub-tabs">

  <Tab label="N Prev Campaigns">

  {#each final_filtered_c_types as ct}

  ### {ct.campaign_type_name}

  <Grid cols=6>
    {#each years as yr}

      {#each n_prev_keys as n}

      <LineChart
        data={new_agg_n_prev.where(`n_prev_campaigns = ${n.n_prev_campaigns}
              and campaign_type_name = '${ct.campaign_type_name}'
              and year = ${yr}
               `)}
        title={`Year ${yr} N Prev Campaigns ${n.n_prev_campaigns}`}
        x=day_of_campaign
        y={m.col}
        yFmt={m.col === 'adjusted_total_donations' ? "0" : "0.00%"}
        series=campaign_treatment
        type=line
        xLabel="Day of Campaign"
        yMin=0.0
        yMax=0.08
        chartAreaHeight=200
        lineWidth=2
        echartsOptions={baseEchartsOptions}
        seriesColors={seriesColors}
        connectGroup={`${m.col}-${yr}-${ct.campaign_type_name}-adjusted-group`}
      >
      <ReferenceLine x={0} label="Campaign Start" hideValue=true/>

    </LineChart>

      {/each}
    {/each}
  </Grid>
{/each}

        <!-- yMax={ -->
        <!--   y_limits_n_prev.find( -->
        <!--     r => -->
        <!--       r.campaign_type_name === ct.campaign_type_name && -->
        <!--       r.metric === m.col -->
        <!--   )?.y_max ?? 0 -->
        <!-- } -->

</Tab>

</Tabs>

</Tab>

{/each}

</Tabs>
