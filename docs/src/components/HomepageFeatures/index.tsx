import clsx from 'clsx';
import Heading from '@theme/Heading';
import styles from './styles.module.css';

type FeatureItem = {
  title: string;
  emoji: string;
  description: JSX.Element;
};

const FeatureList: FeatureItem[] = [
  {
    title: 'Avoid Complexity',
    emoji: '🧠',
    description: (
      <>
        Create robust, unique map-based gameplay features without Luau scripting, quickly.
      </>
    ),
  },
  {
    title: 'Powerful',
    emoji: '⚡',
    description: (
      <>
        Integrate with your game systems to give more capabilities to maps and their developers.
      </>
    ),
  },
  {
    title: 'Safety',
    emoji: '🛡️',
    description: (
      <>
        Practices code sandboxing inherently, allowing you to integrate community-created content easily.
      </>
    ),
  },
  {
    title: 'Customizability',
    emoji: '⚙️',
    description: (
      <>
        Tailored for flexibility, per-game configuration, and usage on both the server and client.
      </>
    ),
  },
];

function Feature({title, emoji, description}: FeatureItem) {
  return (
    <div className={clsx('col col--3')}>
      <div className="text--center">
        <Heading as="h1">{emoji}</Heading>
      </div>
      <div className="text--center padding-horiz--md">
        <Heading as="h3">{title}</Heading>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures(): JSX.Element {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
