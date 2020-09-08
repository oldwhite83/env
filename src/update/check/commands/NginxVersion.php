<?php

namespace Commands;

use GuzzleHttp\Client;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class NginxVersion extends Command
{
    protected function configure()
    {
        $this->setName('version:nginx');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $client = new Client();
        $content = $client->request('GET', 'https://openresty.org/cn/download.html', [
            'headers' => [
                'Accept-Encoding' => 'gzip, deflate',
            ],
        ]);
        $content = (string) $content->getBody();

        preg_match('/<h2>最新版<\/h2>\n<ul>.*?<\/ul>/is', $content, $matches1);
        if (empty($matches1[0])) {
            return null;
        }
        preg_match('/(openresty-.*?)\.tar\.gz/', $matches1[0], $matches);

        $version = empty($matches[1]) ? null : $matches[1];
        $output->writeln($version);
    }
}