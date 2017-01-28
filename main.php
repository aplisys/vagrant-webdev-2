<?php

require_once __DIR__ . '/vendor/autoload.php';

use LukaszJakubek\SPIO\Bank\Bank;
use LukaszJakubek\SPIO\Bank\Rachunek\RachunekInterface;
use LukaszJakubek\SPIO\Bank\Odsetki;
use LukaszJakubek\SPIO\Bank\Transakcja;

function printRachunek(RachunekInterface $rach)
{
    printf('Rachunek: %s | %s | Saldo: %.2f', $rach->getNumer(), $rach->getWlasciciel(), $rach->getSaldo());
    echo PHP_EOL;

    echo $rach->piszHistorie();
    echo PHP_EOL;
}

$bank = new Bank();

/* Rachunek Kowalskiego */
$rachKowalski = $bank->zalozRachunek("1", "Jan", "Kowalski");
$rachKowalski->setMechanizmOdsetkowy(new Odsetki\OdsetkiA(0.01));

$transakcja = new Transakcja\Wplata($rachKowalski, 1500);
$bank->wykonajTransakcje($transakcja);

$transakcja = new Transakcja\Wyplata($rachKowalski, 1000);
$bank->wykonajTransakcje($transakcja);

// Op.3. Nieudana wyplata 1000 przy saldzie 500 bez debetu
$transakcja = new Transakcja\Wyplata($rachKowalski, 1000);
$bank->wykonajTransakcje($transakcja);

// Aktywacja debetu
/** @var RachunekDebetowy */
$rachKowalski = $bank->aktywujDebet($rachKowalski, 10000);

// Op.4. Udana wyplata 1000 przy saldzie 500 i aktywnym debecie 10000
$transakcja = new Transakcja\Wyplata($rachKowalski, 1000);
$bank->wykonajTransakcje($transakcja);

$transakcja = new Transakcja\NaliczenieOdsetek($rachKowalski);
$bank->wykonajTransakcje($transakcja);

/* Rachunek Nowaka */
$rachNowak = $bank->zalozRachunek("2", "Jacek", "Nowak");
$rachNowak->setMechanizmOdsetkowy(new Odsetki\OdsetkiB(0.05, 0.01, 0.05));

$transakcja = new Transakcja\Wplata($rachNowak, 15000);
$bank->wykonajTransakcje($transakcja);

$transakcja = new Transakcja\Przelew($rachNowak, $rachKowalski, 10000);
$bank->wykonajTransakcje($transakcja);

// Op.3. Nieudana wyplata 10000 przy saldzie 5000 bez debetu
$transakcja = new Transakcja\Przelew($rachNowak, $rachKowalski, 10000);
$bank->wykonajTransakcje($transakcja);

$transakcja = new Transakcja\NaliczenieOdsetek($rachNowak);
$bank->wykonajTransakcje($transakcja);

printRachunek($rachKowalski);
printRachunek($rachNowak);
