// SPDX-License-Identifier: GPL-2.0-only

#include <linux/module.h>
#include <net/pkt_sched.h>

struct lbf_params {
};

struct lbf_vars {
};

struct lbf_stats {
	psched_time_t delay;
};

struct lbf_sched_data {
	struct lbf_params params;
	struct lbf_vars vars;
	struct lbf_stats stats;
};

struct lbf_skb_cb {
	psched_time_t enqueue_time;
};

static void lbf_params_init(struct lbf_params *params)
{
}

static void lbf_vars_init(struct lbf_vars *vars)
{
}

static void lbf_stats_init(struct lbf_stats *stats)
{
	stats->delay = PSCHED_PASTPERFECT;
}

static struct lbf_skb_cb *get_lbf_cb(const struct sk_buff *skb)
{
	qdisc_cb_private_validate(skb, sizeof(struct lbf_skb_cb));

	return (struct lbf_skb_cb *)qdisc_skb_cb(skb)->data;
}

static psched_time_t lbf_get_enqueue_time(const struct sk_buff *skb)
{
	return get_lbf_cb(skb)->enqueue_time;
}

static void lbf_set_enqueue_time(struct sk_buff *skb)
{
	get_lbf_cb(skb)->enqueue_time = psched_get_time();
}

static int lbf_enqueue(struct sk_buff *skb, struct Qdisc *sch,
		       struct sk_buff **to_free)
{
	if (unlikely(qdisc_qlen(sch) >= sch->limit))
		return qdisc_drop(skb, sch, to_free);

	lbf_set_enqueue_time(skb);

	return qdisc_enqueue_tail(skb, sch);
}

static struct sk_buff *lbf_dequeue(struct Qdisc *sch)
{
	struct sk_buff *skb = qdisc_dequeue_head(sch);
	struct lbf_sched_data *q;

	if (unlikely(!skb))
		return NULL;

	q = qdisc_priv(sch);

	q->stats.delay = psched_get_time() - lbf_get_enqueue_time(skb);

	return skb;
}

static struct sk_buff *lbf_peek(struct Qdisc *sch)
{
	return qdisc_peek_dequeued(sch);
}

static const struct nla_policy lbf_policy[TCA_LBF_MAX + 1] = {
	[TCA_LBF_LIMIT] = { .type = NLA_U32 }
};

static int lbf_change(struct Qdisc *sch, struct nlattr *opt,
		      struct netlink_ext_ack *extack)
{
	struct nlattr *tb[TCA_LBF_MAX + 1];
	int err;

	if (!opt)
		return -EINVAL;

	err = nla_parse_nested(tb, TCA_LBF_MAX, opt, lbf_policy, NULL);
	if (err < 0)
		return err;

	if (tb[TCA_LBF_LIMIT])
		sch->limit = nla_get_u32(tb[TCA_LBF_LIMIT]);

	return 0;
}

static int lbf_init(struct Qdisc *sch, struct nlattr *opt,
		    struct netlink_ext_ack *extack)
{
	struct lbf_sched_data *q = qdisc_priv(sch);

	sch->limit = 1000;

	lbf_params_init(&q->params);
	lbf_vars_init(&q->vars);
	lbf_stats_init(&q->stats);

	return lbf_change(sch, opt, extack);
}

static void lbf_reset(struct Qdisc *sch)
{
	qdisc_reset_queue(sch);
}

static void lbf_destroy(struct Qdisc *sch)
{
}

//static void lbf_attach(struct Qdisc *sch)
//{
//}

//static int lbf_change_tx_queue_len(struct Qdisc *sch, unsigned int new_len)
//{
//	return 0;
//}

static int lbf_dump(struct Qdisc *sch, struct sk_buff *skb)
{
	struct nlattr *opts;

	opts = nla_nest_start(skb, TCA_OPTIONS);
	if (unlikely(!opts))
		return -EMSGSIZE;

	if (nla_put_u32(skb, TCA_LBF_LIMIT, sch->limit))
		goto nla_put_failure;

	return nla_nest_end(skb, opts);

nla_put_failure:
	nla_nest_cancel(skb, opts);
	return -EMSGSIZE;
}

static int lbf_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
{
	struct lbf_sched_data *q = qdisc_priv(sch);
	struct tc_lbf_xstats st = {
		.delay = div_u64(PSCHED_TICKS2NS(q->stats.delay), NSEC_PER_USEC)
	};

	return gnet_stats_copy_app(d, &st, sizeof(st));
}

//static void lbf_ingress_block_set(struct Qdisc *sch, u32 block_index)
//{
//}

//static void lbf_egress_block_set(struct Qdisc *sch, u32 block_index)
//{
//}

//static u32 lbf_ingress_block_get(struct Qdisc *sch)
//{
//	return U32_MIN;
//}

//static u32 lbf_egress_block_get(struct Qdisc *sch)
//{
//	return U32_MIN;
//}

static struct Qdisc_ops lbf_qdisc_ops __read_mostly = {
	.id			= "lbf",
	.priv_size		= sizeof(struct lbf_sched_data),
//	.static_flags		= 0U,

	.enqueue		= lbf_enqueue,
	.dequeue		= lbf_dequeue,
	.peek			= lbf_peek,

	.init			= lbf_init,
	.reset			= lbf_reset,
	.destroy		= lbf_destroy,
	.change			= lbf_change,
//	.attach			= lbf_attach,
//	.change_tx_queue_len	= lbf_change_tx_queue_len,

	.dump			= lbf_dump,
	.dump_stats		= lbf_dump_stats,

//	.ingress_block_set	= lbf_ingress_block_set,
//	.egress_block_set	= lbf_egress_block_set,
//	.ingress_block_get	= lbf_ingress_block_get,
//	.egress_block_get	= lbf_egress_block_get,

	.owner			= THIS_MODULE
};

static int __init lbf_module_init(void)
{
	return register_qdisc(&lbf_qdisc_ops);
}

static void __exit lbf_module_exit(void)
{
	unregister_qdisc(&lbf_qdisc_ops);
}

module_init(lbf_module_init);
module_exit(lbf_module_exit);

MODULE_DESCRIPTION("Latency Based Forwarding queue discipline");
MODULE_AUTHOR(""); /* TODO: Bhaskar's Name */
MODULE_AUTHOR(""); /* TODO: Rohit's Name */
MODULE_LICENSE("GPL v2");
