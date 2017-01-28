<?php
/**
 * Definicja klasy RachunekDebetowy
 */

namespace LukaszJakubek\SPIO\Bank\Rachunek;

use LukaszJakubek\SPIO\Bank\Odsetki\OdsetkiInterface;
use LukaszJakubek\SPIO\Bank\Odsetki\OdsetkiA;
use LukaszJakubek\SPIO\Bank\Transakcja\TransakcjaInterface;

/**
 * Rachunek debetwy klienta banku
 *
 * Rachunek posiada podstawowe atrybuty takie jak numer, imię i nazwisko
 * właściciela oraz saldo, dopuszczalnyDebet i przypisany mechanizm odsetkowy.
 * Pozwala wypłacać pieniądze również wykozystując debet.
 *
 * @author Lukasz Jakubek <lukasz.jakubek@aplisys.pl>
 */
class RachunekDebetowy implements RachunekInterface
{
    /**
     * Rachunek podstawowy
     *
     * @var Rachunek
     */
    private $rachunek;

    /**
     * Dopuszczalny debet rachunku w groszach
     *
     * @var int
     */
    private $dopuszczalnyDebet = 0;

    /**
     * Aktualna wartość debetu
     *
     * @var int
     */
    private $debet = 0;

    /**
     * Utworzenie rachunku
     *
     * @param Rachunek $rachunek
     * @param int $dopuszczalnyDebet
     */
    public function __construct(Rachunek $rachunek, $dopuszczalnyDebet)
    {
        $this->rachunek = $rachunek;
        $this->dopuszczalnyDebet = $dopuszczalnyDebet;
    }

    /**
     * Zwraca numer rachunku
     *
     * @return string
     */
    public function getNumer()
    {
        return $this->rachunek->getNumer();
    }

    /**
     * Zwraca właściciela rachunu
     *
     * @return string
     */
    public function getWlasciciel()
    {
        return $this->rachunek->getWlasciciel();
    }

    /**
     * Zwraca saldo rachunku
     *
     * @return int
     */
    public function getSaldo()
    {
        return $this->rachunek->getSaldo() - $this->debet;
    }

    /**
     * Ustawia dopuszczalny debet
     *
     * @param int $dopuszczalnyDebet
     * @return RachunekDebetowy
     */
    public function setDopuszczalnyDebet(int $dopuszczalnyDebet)
    {
        $this->dopuszczalnyDebet = $dopuszczalnyDebet;

        return $this;
    }

    /**
     * Zwraca dopuszczalny debet
     *
     * @return int
     */
    public function getDopuszczalnyDebet()
    {
        return $this->dopuszczalnyDebet;
    }

    /**
     * Wypisuje historie
     *
     * return string
     */
    public function piszHistorie()
    {
        return $this->rachunek->piszHistorie();
    }

    /**
     * Zwraca mechanizm odsetkowy
     *
     * @return OdsetkiInterface
     */
    public function getMechanizmOdsetkowy()
    {
        return $this->rachunek->getMechanizmOdsetkowy();
    }

    /**
     * Ustawia saldo rachunku
     *
     * @param int wartosc
     * @return RachunekDebetowy
     */
    public function setSaldo($wartosc)
    {
        $this->debet = 0;
        if ($wartosc < 0) {
            $this->debet = -$wartosc;
            $wartosc = 0;
        }

        $this->rachunek->setSaldo($wartosc);

        return $this;
    }

    /**
     * Zapisuje historię
     *
     * @param TransakcjaInterface $transakcja
     * @return RachunekDebetowy
     */
    public function addHistoria(TransakcjaInterface $transakcja)
    {
        $this->rachunek->addHistoria($transakcja);

        return $this;
    }
}
