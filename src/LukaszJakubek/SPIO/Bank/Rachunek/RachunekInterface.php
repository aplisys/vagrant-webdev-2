<?php
/**
 * Definicja interfejsu RachunekInterface
 */

namespace LukaszJakubek\SPIO\Bank\Rachunek;

use LukaszJakubek\SPIO\Bank\Odsetki\OdsetkiInterface;
use LukaszJakubek\SPIO\Bank\Transakcja\TransakcjaInterface;

/**
 * Udostępnia metody do manipulacji rachunkiem bankowym dowolnego typu
 *
 * @author Lukasz Jakubek <lukasz.jakubek@aplisys.pl>
 */
interface RachunekInterface
{
    /**
     * Zwraca numer rachunku
     *
     * @return string
     */
    public function getNumer();

    /**
     * Zwraca właściciela rachunu
     *
     * @return string
     */
    public function getWlasciciel();

    /**
     * Zwraca saldo rachunku
     *
     * @return int
     */
    public function getSaldo();

    /**
     * Ustawia saldo rachunku
     *
     * @param int wartosc
     * @return Rachunek
     */
    public function setSaldo($wartosc);

    /**
     * Zapisuje historię
     *
     * @param TransakcjaInterface $transakcja
     * @return Rachunek
     */
    public function addHistoria(TransakcjaInterface $transakcja);

    /**
     * Wypisuje historie
     *
     * return string
     */
    public function piszHistorie();

    /**
     * Zwraca mechanizm odsetkowy
     *
     * @return OdsetkiInterface
     */
    public function getMechanizmOdsetkowy();

    /**
     * Zwraca dopuszczalny debet
     *
     * @return int
     */
    public function getDopuszczalnyDebet();
}
