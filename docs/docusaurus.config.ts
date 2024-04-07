import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

const config: Config = {
  title: 'ChainLink',
  tagline: 'DataModel-driven logic and control system for Roblox',

  url: 'https://github.com',
  baseUrl: '/ChainLink/',
  trailingSlash: false,

  organizationName: 'Hex-Interactive',
  projectName: 'ChainLink',

  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',

  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  markdown: {
    mermaid: true,
  },

  themes: ['@docusaurus/theme-mermaid'],

  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.ts',
          editUrl: 'https://github.com/Hex-Interactive/ChainLink/edit/main/docs/'
        },
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    colorMode: {
      defaultMode: 'dark',
    },
    navbar: {
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'chainlink',
          position: 'left',
          label: 'ChainLink',
        },
        {
          type: 'docSidebar',
          sidebarId: 'chain',
          position: 'left',
          label: 'Chain',
        },
        {
          href: 'https://github.com/Hex-Interactive/ChainLink',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },

    footer: {
      links: [
        {
          title: 'ChainLink',
          items: [
            {
              label: 'Introduction',
              to: '/docs/chainlink',
            },
            {
              label: 'Installation',
              to: '/docs/chainlink/getting-started/installation',
            },
            {
              label: 'Configuration',
              to: '/docs/chainlink/getting-started/configuration',
            },
          ],
        },
        {
          title: 'Chain',
          items: [
            {
              label: 'Introduction',
              to: '/docs/chain',
            },
          ],
        },
        {
          title: 'Links',
          items: [
            {
              label: 'GitHub',
              href: 'https://github.com/Hex-Interactive/ChainLink',
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} Hex Interactive.`,
    },

    prism: {
      additionalLanguages: ['lua'],
      theme: prismThemes.dracula,
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
