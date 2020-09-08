<?php

namespace Commands;

use GuzzleHttp\Client;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class ComposerMd5 extends Command
{
    protected function configure()
    {
        $this->setName('md5:composer');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $md5 = md5_file('https://dl.laravel-china.org/composer.phar');

        $output->writeln($md5);
    }
}