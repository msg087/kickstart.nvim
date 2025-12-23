# Evidence.dev Test Document

## Components
<Tabs>
  <Tab title="Data">
    <LineChart data={query1} />
  </Tab>
</Tabs>

<Grid>
  <Value data={metric} />
</Grid>

## Control Blocks
{#each items as item}
  <div>{item.name}</div>
{/each}

{#if condition}
  <p>Conditional content</p>
{/if}

## Expressions
The value is {variable}.

## SQL with Interpolations
```sql
select *
from table
where date = ${date_param}
  and value > ${min_value}
```

## Script Block
<script>
  let data = [];
</script>