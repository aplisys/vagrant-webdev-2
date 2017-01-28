<?php
/**
 * Definicja klasy Rachunek
 */

namespace LukaszJakubek\SPIO\Bank\Rachunek;

use LukaszJakubek\SPIO\Bank\Odsetki\OdsetkiInterface;
use LukaszJakubek\SPIO\Bank\Odsetki\OdsetkiA;
use LukaszJakubek\SPIO\Bank\Transakcja\TransakcjaInterface;

/**
 * Rachunek klienta banku
 *
 * Rachunek posiada podstawowe atrybuty takie jak numer, imię i nazwisko
 * właściciela oraz saldo, dopuszczalnyDebet i przypisany mechanizm odsetkowy.
 *
 * @author Lukasz Jakubek <lukasz.jakubek@aplisys.pl>
 */
class Rachunek implements RachunekInterface
{
    /**
     * Unikatowy numer rachunku
     *
     * @var string
     */
    private $numer;

    /**
     * Imię właściciela
     *
     * @var string
     */
    private $imie;

    /**
     * Nazwisko właściciela
     *
     * @var string
     */
    private $nazwisko;

    /**
     * Aktualne saldo rachunku w groszach
     *
     * @var int
     */
    private $saldo = 0;

    /**
     * Historia rachunku w postaci tablicy transakcji
     *
     * @var array
     */
    private $historia = [];

    /**
     * Mechanizm odsetkowy przypisany do rachunku
     *
     * @var OdsetkiInterface
     */
    private $mechanizmOdsetkowy;

    /**
     * Utworzenie rachunku
     *
     * @param string $numer
     * @param string $imie
     * @param string $nazwisko
     */
    public function __construct($numer, $imie, $nazwisko)
    {
        $this->numer = $numer;
        $this->imie = $imie;
        $this->nazwisko = $nazwisko;
        $this->mechanizmOdsetkowy = new OdsetkiA(0.0);
    }

    /**
     * Zwraca numer rachunku
     *
     * @return string
     */
    public function getNumer()
    {
        return $this->numer;
    }

    /**
     * Zwraca właściciela rachunu
     *
     * @return string
     */
    public function getWlasciciel()
    {
        return trim(sprintf('%s %s', $this->imie, $this->nazwisko));
    }

    /**
     * Zwraca saldo rachunku
     *
     * @return int
     */
    public function getSaldo()
    {
        return $this->saldo;
    }

    /**
     * Zwraca dopuszczalny debet
     *
     * @return int
     */
    public function getDopuszczalnyDebet()
    {
        return 0;
    }

    /**
     * Wypisuje historie
     *
     * return string
     */
    public function piszHistorie()
    {
        $output = '[' . PHP_EOL;
        foreach ($this->historia as $transakcja) {
            $output .= '    ' . $transakcja . PHP_EOL;
        }
        $output .= ']' . PHP_EOL;

        return $output;
    }

    /**
     * Ustawia mechanizm odsetkowy
     *
     * @param OdsetkiInterface $mechanizmOdsetkowy
     * @return Rachunek
     */
    public function setMechanizmOdsetkowy(OdsetkiInterface $mechanizmOdsetkowy)
    {
        $this->mechanizmOdsetkowy = $mechanizmOdsetkowy;

        return $this;
    }

    /**
     * Zwraca mechanizm odsetkowy
     *
     * @return OdsetkiInterface
     */
    public function getMechanizmOdsetkowy()
    {
        return $this->mechanizmOdsetkowy;
    }

    /**
     * Ustawia saldo rachunku
     *
     * @param int wartosc
     * @return Rachunek
     */
    public function setSaldo($wartosc)
    {
        $this->saldo = $wartosc;

        return $this;
    }

    /**
     * Zapisuje historię
     *
     * @param TransakcjaInterface $transakcja
     * @return Rachunek
     */
    public function addHistoria(TransakcjaInterface $transakcja)
    {
        $this->historia[] = $transakcja;

        return $this;
    }
}
